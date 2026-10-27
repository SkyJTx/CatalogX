import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/constants.dart';
import '/models/app_language.dart';
import '/models/catalog_sort_option.dart';
import '/state/catalog_notifier.dart';
import '/state/catalog_state.dart';
import '/state/locale_notifier.dart';
import '/state/wishlist_notifier.dart';
import '/theme.dart';
import '/ui/components/catalog_search_bar.dart';
import '/ui/components/category_filter_bar.dart';
import '/ui/components/product_card.dart';
import '/ui/components/product_grid_skeleton.dart';
import '/ui/components/settings_sheet.dart';
import '/ui/components/state_feedback_view.dart';
import '/ui/localization/app_strings.dart';

class HomeWidget extends ConsumerWidget {
  const HomeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final catalogState = ref.watch(catalogProvider);
    final currentLang = ref.watch(localeProvider);
    final strings = ref.watch(appStringsProvider);
    final wishlistCount = ref.watch(
      wishlistProvider.select((map) => map.length),
    );
    final cartCount = ref.watch(cartCountProvider);

    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

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
      defaultValue: 12,
      conditionalValues: const <Condition<double>>[
        Condition<double>.equals(name: MOBILE, value: 12),
        Condition<double>.equals(name: TABLET, value: 16),
        Condition<double>.largerThan(name: TABLET, value: 20),
      ],
    ).value;

    final cardAspectRatio = ResponsiveValue<double>(
      context,
      defaultValue: 0.62,
      conditionalValues: const <Condition<double>>[
        Condition<double>.equals(name: MOBILE, value: 0.62),
        Condition<double>.equals(name: TABLET, value: 0.66),
        Condition<double>.largerThan(name: TABLET, value: 0.70),
      ],
    ).value;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: horizontalPadding,
        title: Row(
          children: <Widget>[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                LucideIcons.store,
                size: 20,
                color: Colors.white,
              ),
            ),
            const Gap(10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    strings.appTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  if (!isMobile)
                    Text(
                      strings.appSubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Material(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(999),
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () {
                  ref.read(localeProvider.notifier).toggleLanguage();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        LucideIcons.languages,
                        size: 15,
                        color: scheme.primary,
                      ),
                      const Gap(5),
                      Text(
                        currentLang == AppLanguage.th ? 'TH' : 'EN',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: scheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Gap(4),
          IconButton(
            tooltip: strings.wishlistFilterLabel(wishlistCount),
            onPressed: () {
              if (catalogState.isWishlistOnly) {
                ref.read(catalogProvider.notifier).selectCategory(null);
              } else {
                ref.read(catalogProvider.notifier).selectWishlistOnly();
              }
            },
            icon: Badge(
              isLabelVisible: wishlistCount > 0,
              label: Text('$wishlistCount'),
              backgroundColor: AppPalette.discountRose,
              child: Icon(
                catalogState.isWishlistOnly
                    ? Icons.favorite
                    : LucideIcons.heart,
                size: 20,
                color: catalogState.isWishlistOnly
                    ? AppPalette.discountRose
                    : scheme.onSurface,
              ),
            ),
          ),
          IconButton(
            onPressed: () => SettingsSheet.show(context),
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              backgroundColor: scheme.primary,
              child: const Icon(LucideIcons.shoppingBag, size: 20),
            ),
          ),
          IconButton(
            tooltip: strings.settingsSheetTitle,
            onPressed: () => SettingsSheet.show(context),
            icon: const Icon(LucideIcons.settings2, size: 20),
          ),
          Gap(horizontalPadding - 8),
        ],
      ),
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
                    12,
                    horizontalPadding,
                    8,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                LucideIcons.arrowDown,
                                size: 13,
                                color: scheme.primary,
                              ),
                              const Gap(5),
                              Flexible(
                                child: Text(
                                  strings.pullToRefreshHint,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(10),
                        const CatalogSearchBar(),
                        const Gap(12),
                        const CategoryFilterBar(),
                        const Gap(12),
                        _CatalogToolbarRow(
                          catalogState: catalogState,
                          strings: strings,
                          isMobile: isMobile,
                        ),
                      ],
                    ),
                  ),
                ),
                if (catalogState.isInitialLoading)
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 8,
                    ),
                    sliver: ProductGridSkeleton(
                      crossAxisCount: gridColumns,
                      childAspectRatio: cardAspectRatio,
                      spacing: gridSpacing,
                    ),
                  )
                else if (catalogState.error != null)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: EdgeInsets.all(horizontalPadding),
                      child: StateFeedbackView.error(
                        title: strings.errorStateTitle,
                        message: catalogState.error!.localizedMessage(
                          currentLang,
                        ),
                        retryLabel: strings.retryButtonLabel,
                        onRetry: () {
                          ref.read(catalogProvider.notifier).refresh();
                        },
                      ),
                    ),
                  )
                else if (catalogState.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: EdgeInsets.all(horizontalPadding),
                      child: StateFeedbackView.empty(
                        title: strings.emptyStateTitle,
                        subtitle: catalogState.isWishlistOnly
                            ? strings.emptyWishlistSubtitle
                            : strings.emptyStateSubtitle,
                        resetLabel: strings.resetFiltersButton,
                        onReset: () {
                          ref.read(catalogProvider.notifier).resetFilters();
                        },
                      ),
                    ),
                  )
                else ...<Widget>[
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 6,
                    ),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridColumns,
                        mainAxisSpacing: gridSpacing,
                        crossAxisSpacing: gridSpacing,
                        childAspectRatio: cardAspectRatio,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = catalogState.products[index];
                          return ProductCard(product: product);
                        },
                        childCount: catalogState.products.length,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      16,
                      horizontalPadding,
                      32,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _CatalogPaginationFooter(
                        catalogState: catalogState,
                        strings: strings,
                        currentLang: currentLang,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CatalogToolbarRow extends ConsumerWidget {
  final CatalogState catalogState;
  final AppStrings strings;
  final bool isMobile;

  const _CatalogToolbarRow({
    required this.catalogState,
    required this.strings,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      children: <Widget>[
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: scheme.primary,
            shape: BoxShape.circle,
          ),
        ),
        const Gap(7),
        Expanded(
          child: Text(
            strings.showingResultsCount(
              catalogState.products.length,
              catalogState.total,
            ),
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (isMobile)
          PopupMenuButton<CatalogSortOption>(
            initialValue: catalogState.sortOption,
            onSelected: (option) {
              ref.read(catalogProvider.notifier).updateSort(option);
            },
            itemBuilder: (context) {
              return CatalogSortOption.values.map((option) {
                return PopupMenuItem<CatalogSortOption>(
                  value: option,
                  child: Text(strings.sortLabel(option)),
                );
              }).toList(growable: false);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    strings.sortLabel(catalogState.sortOption),
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Gap(4),
                  Icon(
                    LucideIcons.chevronDown,
                    size: 14,
                    color: scheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _CatalogPaginationFooter extends ConsumerWidget {
  final CatalogState catalogState;
  final AppStrings strings;
  final AppLanguage currentLang;

  const _CatalogPaginationFooter({
    required this.catalogState,
    required this.strings,
    required this.currentLang,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          children: <Widget>[
            Text(
              strings.pageProgressText(
                currentPage: catalogState.currentPage,
                totalPages: catalogState.totalPages,
                loaded: catalogState.products.length,
                total: catalogState.total,
              ),
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(8),
            SizedBox(
              width: 180,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: catalogState.loadProgress,
                  minHeight: 5,
                  backgroundColor: scheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(scheme.primary),
                ),
              ),
            ),
            const Gap(12),
            if (catalogState.loadMoreError != null) ...<Widget>[
              Text(
                catalogState.loadMoreError!.localizedMessage(currentLang),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.error,
                ),
              ),
              const Gap(8),
            ],
            if (catalogState.hasMore)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: catalogState.isLoadingMore
                      ? null
                      : () {
                          ref.read(catalogProvider.notifier).loadMore();
                        },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: scheme.surfaceContainerLow,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  icon: catalogState.isLoadingMore
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: scheme.primary,
                          ),
                        )
                      : Icon(
                          LucideIcons.refreshCw,
                          size: 16,
                          color: scheme.primary,
                        ),
                  label: Text(
                    catalogState.isLoadingMore
                        ? strings.loadingMoreButton
                        : strings.loadMoreButton,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )
            else
              Text(
                strings.allProductsLoaded,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}