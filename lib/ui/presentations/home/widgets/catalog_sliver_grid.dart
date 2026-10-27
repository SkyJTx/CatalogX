import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '/state/catalog_notifier.dart';
import '/state/locale_notifier.dart';
import '/ui/components/product_card/product_card.dart';
import '/ui/components/product_grid_skeleton.dart';
import '/ui/components/state_feedback_view.dart';

class CatalogSliverGrid extends ConsumerWidget {
  final double horizontalPadding;
  final int gridColumns;
  final double gridSpacing;
  final double cardAspectRatio;

  const CatalogSliverGrid({
    super.key,
    required this.horizontalPadding,
    required this.gridColumns,
    required this.gridSpacing,
    required this.cardAspectRatio,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogProvider);
    final currentLang = ref.watch(localeProvider);
    final strings = ref.watch(appStringsProvider);

    if (catalogState.isInitialLoading) {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        sliver: ProductGridSkeleton(
          crossAxisCount: gridColumns,
          childAspectRatio: cardAspectRatio,
          spacing: gridSpacing,
        ),
      );
    }

    if (catalogState.error != null && catalogState.products.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: StateFeedbackView.error(
          title: strings.errorStateTitle,
          message: catalogState.error!.localizedMessage(currentLang),
          retryLabel: strings.retryButtonLabel,
          onRetry: () {
            ref.read(catalogProvider.notifier).refresh();
          },
        ),
      );
    }

    if (catalogState.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: StateFeedbackView.empty(
          title: strings.emptyStateTitle,
          subtitle: catalogState.isWishlistOnly
              ? strings.emptyWishlistSubtitle
              : strings.emptyStateSubtitle,
          resetLabel: strings.resetFiltersButton,
          isWishlist: catalogState.isWishlistOnly,
          onReset: () {
            ref.read(catalogProvider.notifier).resetFilters();
          },
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
            return ProductCard(
              key: ValueKey<int>(product.id),
              product: product,
            );
          },
          childCount: catalogState.products.length,
        ),
      ),
    );
  }
}
