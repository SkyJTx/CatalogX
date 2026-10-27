import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '../../../models/product.dart';
import '../../../models/product_review.dart';
import '../../../state/wishlist_notifier.dart';
import '../../../theme.dart';
import '../../localization/app_strings.dart';
import 'product_gallery_section.dart';

class ProductInfoSection extends ConsumerWidget {
  final Product product;
  final AppStrings strings;
  final int quantity;
  final int selectedTabIndex;
  final bool showInlineActionButtons;
  final bool showBottomTrustBadges;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<int> onTabSelected;

  const ProductInfoSection({
    super.key,
    required this.product,
    required this.strings,
    required this.quantity,
    required this.selectedTabIndex,
    required this.showInlineActionButtons,
    required this.showBottomTrustBadges,
    required this.onQuantityChanged,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final stockColor = product.isOutOfStock || product.isLowStock
        ? AppPalette.discountRose
        : AppPalette.inStockEmerald;
    final stockBg = product.isOutOfStock || product.isLowStock
        ? (isDark
            ? AppPalette.discountRoseBgDark
            : AppPalette.discountRoseBgLight)
        : (isDark
            ? AppPalette.inStockEmeraldBgDark
            : AppPalette.inStockEmeraldBgLight);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  product.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                const Gap(10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: scheme.secondary,
                          ),
                          const Gap(4),
                          Text(
                            '${product.rating.toStringAsFixed(1)} (${strings.reviewsCountLabel(product.reviews.length)})',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            LucideIcons.shieldCheck,
                            size: 14,
                            color: scheme.primary,
                          ),
                          const Gap(5),
                          Text(
                            product.warrantyInformation,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(14),
                Wrap(
                  spacing: 10,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Text(
                      strings.formatPrice(product.price),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (product.hasDiscount) ...<Widget>[
                      Text(
                        strings.formatPrice(product.originalPrice),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppPalette.discountRoseBgDark
                              : AppPalette.discountRoseBgLight,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          strings.saveBadge(
                            strings.formatPrice(product.savingsAmount),
                          ),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppPalette.discountRose,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const Gap(12),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: stockBg,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: stockColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const Gap(6),
                          Text(
                            product.isOutOfStock
                                ? strings.outOfStockBadge
                                : (product.isLowStock
                                    ? strings.lowStockBadge(product.stock)
                                    : strings.inStockBadge(product.stock)),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: stockColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          LucideIcons.truck,
                          size: 15,
                          color: scheme.onSurfaceVariant,
                        ),
                        const Gap(5),
                        Text(
                          product.shippingInformation,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Gap(16),
                const Divider(height: 1),
                const Gap(14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        strings.quantityLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Gap(8),
                    Container(
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: scheme.outlineVariant),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            onPressed: quantity > 1
                                ? () => onQuantityChanged(quantity - 1)
                                : null,
                            icon: const Icon(LucideIcons.minus, size: 16),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '$quantity',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: quantity < product.stock
                                ? () => onQuantityChanged(quantity + 1)
                                : null,
                            icon: const Icon(LucideIcons.plus, size: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (showInlineActionButtons) ...<Widget>[
                  const Gap(16),
                  DetailActionButtons(
                    product: product,
                    quantity: quantity,
                    strings: strings,
                  ),
                ],
              ],
            ),
          ),
        ),
        const Gap(14),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: _TabPillButton(
                          label: strings.tabOverview,
                          isSelected: selectedTabIndex == 0,
                          onTap: () => onTabSelected(0),
                        ),
                      ),
                      Expanded(
                        child: _TabPillButton(
                          label: strings.tabShippingAndReturns,
                          isSelected: selectedTabIndex == 1,
                          onTap: () => onTabSelected(1),
                        ),
                      ),
                      Expanded(
                        child: _TabPillButton(
                          label: strings.tabReviews(product.reviews.length),
                          isSelected: selectedTabIndex == 2,
                          onTap: () => onTabSelected(2),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                if (selectedTabIndex == 0) ...<Widget>[
                  Text(
                    product.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.55,
                    ),
                  ),
                  const Gap(16),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _SpecBox(
                          title: strings.specDimensionsTitle,
                          primaryValue: product.dimensions.formatted,
                          secondaryValue: strings.specWeightValue(
                            product.weight,
                          ),
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: _SpecBox(
                          title: strings.specSkuTitle,
                          primaryValue: product.sku,
                          secondaryValue: strings.specMinOrderValue(
                            product.minimumOrderQuantity,
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else if (selectedTabIndex == 1) ...<Widget>[
                  _SpecBox(
                    title: strings.specShippingTitle,
                    primaryValue: product.shippingInformation,
                    secondaryValue: product.availabilityStatus,
                  ),
                  const Gap(10),
                  _SpecBox(
                    title: strings.specWarrantyTitle,
                    primaryValue: product.warrantyInformation,
                    secondaryValue:
                        '${strings.specReturnPolicyTitle}: ${product.returnPolicy}',
                  ),
                  if (product.meta.barcode.isNotEmpty) ...<Widget>[
                    const Gap(10),
                    _SpecBox(
                      title: strings.specBarcodeTitle,
                      primaryValue: product.meta.barcode,
                      secondaryValue: product.brand,
                    ),
                  ],
                ] else ...<Widget>[
                  if (product.reviews.isEmpty)
                    Text(
                      strings.noReviewsMessage,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    )
                  else
                    Column(
                      children: product.reviews
                          .map(
                            (review) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _ReviewTile(
                                review: review,
                                strings: strings,
                              ),
                            ),
                          )
                          .toList(growable: false),
                    ),
                ],
              ],
            ),
          ),
        ),
        if (showBottomTrustBadges) ...<Widget>[
          const Gap(14),
          TrustBadgesRow(strings: strings),
        ],
      ],
    );
  }
}

class _TabPillButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabPillButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: isSelected ? scheme.surfaceContainerLow : Colors.transparent,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _SpecBox extends StatelessWidget {
  final String title;
  final String primaryValue;
  final String secondaryValue;

  const _SpecBox({
    required this.title,
    required this.primaryValue,
    required this.secondaryValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const Gap(4),
          Text(
            primaryValue,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(2),
          Text(
            secondaryValue,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final ProductReview review;
  final AppStrings strings;

  const _ReviewTile({
    required this.review,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  review.reviewerName,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Row(
                children: List<Widget>.generate(5, (idx) {
                  return Icon(
                    Icons.star_rounded,
                    size: 14,
                    color: idx < review.rating
                        ? scheme.secondary
                        : scheme.outlineVariant,
                  );
                }),
              ),
            ],
          ),
          const Gap(4),
          Text(
            review.comment,
            style: theme.textTheme.bodySmall?.copyWith(
              height: 1.4,
            ),
          ),
          const Gap(4),
          Text(
            strings.formatDate(review.date),
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailBottomActionBar extends StatelessWidget {
  final Product product;
  final int quantity;
  final AppStrings strings;

  const DetailBottomActionBar({
    super.key,
    required this.product,
    required this.quantity,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        border: Border(top: BorderSide(color: scheme.outlineVariant)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: DetailActionButtons(
            product: product,
            quantity: quantity,
            strings: strings,
          ),
        ),
      ),
    );
  }
}

class DetailActionButtons extends ConsumerWidget {
  final Product product;
  final int quantity;
  final AppStrings strings;

  const DetailActionButtons({
    super.key,
    required this.product,
    required this.quantity,
    required this.strings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final isWishlisted = ref.watch(
      wishlistProvider.select((map) => map.containsKey(product.id)),
    );

    return Row(
      children: <Widget>[
        Material(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              ref.read(wishlistProvider.notifier).toggle(product);
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(
                isWishlisted ? Icons.favorite : LucideIcons.heart,
                size: 20,
                color: isWishlisted
                    ? AppPalette.discountRose
                    : scheme.onSurface,
              ),
            ),
          ),
        ),
        const Gap(10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: product.isOutOfStock
                ? null
                : () {
                    ref
                        .read(cartCountProvider.notifier)
                        .addItems(product, quantity: quantity);
                  },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(LucideIcons.shoppingBag, size: 17),
            label: Text(
              strings.addToCartButton,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const Gap(10),
        Expanded(
          child: FilledButton.icon(
            onPressed: product.isOutOfStock
                ? null
                : () {
                    ref
                        .read(cartCountProvider.notifier)
                        .addItems(product, quantity: quantity);
                  },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(LucideIcons.zap, size: 17),
            label: Text(
              strings.buyNowButton,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}