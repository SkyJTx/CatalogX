import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/constants.dart';
import '/state/catalog_notifier.dart';
import '/ui/components/catalog_search_bar.dart';
import '/ui/components/category_filter_bar.dart';
import '/ui/presentations/home/widgets/catalog_pagination_footer.dart';
import '/ui/presentations/home/widgets/catalog_sliver_grid.dart';
import '/ui/presentations/home/widgets/catalog_toolbar.dart';
import '/ui/presentations/home/widgets/home_app_bar.dart';

class HomeWidget extends ConsumerWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final hasProducts = ref.watch(
      catalogProvider.select((s) => !s.isInitialLoading && s.products.isNotEmpty),
    );

    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16,
      conditionalValues: const <Condition<double>>[
        Condition<double>.equals(name: MOBILE, value: 16),
        Condition<double>.equals(name: TABLET, value: 24),
        Condition<double>.largerThan(name: TABLET, value: 32),
      ],
    ).value;

    final gridColumns = ResponsiveValue<int>(
      context,
      defaultValue: 2,
      conditionalValues: const <Condition<int>>[
        Condition<int>.equals(name: MOBILE, value: 2),
        Condition<int>.equals(name: TABLET, value: 3),
        Condition<int>.largerThan(name: TABLET, value: 4),
      ],
    ).value;

    final gridSpacing = ResponsiveValue<double>(
      context,
      defaultValue: 16,
      conditionalValues: const <Condition<double>>[
        Condition<double>.equals(name: MOBILE, value: 16),
        Condition<double>.equals(name: TABLET, value: 22),
        Condition<double>.largerThan(name: TABLET, value: 26),
      ],
    ).value;

    final cardAspectRatio = ResponsiveValue<double>(
      context,
      defaultValue: 0.62,
      conditionalValues: const <Condition<double>>[
        Condition<double>.equals(name: MOBILE, value: 0.60),
        Condition<double>.equals(name: TABLET, value: 0.65),
        Condition<double>.largerThan(name: TABLET, value: 0.68),
      ],
    ).value;

    return Scaffold(
      appBar: const HomeAppBar(),
      body: MaxWidthBox(
        maxWidth: LayoutConstants.contentMaxWidth,
        backgroundColor: theme.scaffoldBackgroundColor,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.maxScrollExtent > 0 &&
                notification.metrics.pixels >=
                    notification.metrics.maxScrollExtent * 0.85) {
              ref.read(catalogProvider.notifier).loadMore();
            }
            return false;
          },
          child: RefreshIndicator(
            onRefresh: () => ref.read(catalogProvider.notifier).refresh(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    20,
                    horizontalPadding,
                    12,
                  ),
                  sliver: const SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CatalogSearchBar(),
                        Gap(14),
                        CategoryFilterBar(),
                        Gap(14),
                        CatalogToolbar(),
                      ],
                    ),
                  ),
                ),
                CatalogSliverGrid(
                  horizontalPadding: horizontalPadding,
                  gridColumns: gridColumns,
                  gridSpacing: gridSpacing,
                  cardAspectRatio: cardAspectRatio,
                ),
                if (hasProducts)
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      28,
                      horizontalPadding,
                      44,
                    ),
                    sliver: const SliverToBoxAdapter(
                      child: CatalogPaginationFooter(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
