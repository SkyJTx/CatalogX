import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '/models/product.dart';
import '/state/wishlist_notifier.dart';
import '/ui/localization/app_strings.dart';

class ProductCardInfo extends ConsumerWidget {
  final Product product;
  final AppLocalization strings;

  const ProductCardInfo({
    super.key,
    required this.product,
    required this.strings,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final stockText = product.isOutOfStock
        ? strings.outOfStockBadge
        : (product.isLowStock
            ? strings.lowStockBadge(product.stock)
            : strings.inStockBadge(product.stock));
    final stockColor = product.isOutOfStock || product.isLowStock
        ? scheme.error
        : scheme.onSurfaceVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    product.brand.isNotEmpty
                        ? product.brand.toUpperCase()
                        : product.category.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                const Gap(4),
                Icon(
                  Icons.star_rounded,
                  size: 13,
                  color: scheme.secondary,
                ),
                const Gap(2),
                Text(
                  product.rating.toStringAsFixed(1),
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
            const Gap(4),
            Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                height: 1.25,
                color: scheme.onSurface,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    children: <Widget>[
                      Text(
                        strings.formatPrice(product.price),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: scheme.onSurface,
                        ),
                      ),
                      if (product.hasDiscount)
                        Text(
                          strings.formatPrice(product.originalPrice),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                            decoration: TextDecoration.lineThrough,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ),
                Material(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: product.isOutOfStock
                        ? null
                        : () {
                            ref
                                .read(cartCountProvider.notifier)
                                .addItems(product);
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        LucideIcons.plus,
                        size: 15,
                        color: product.isOutOfStock
                            ? scheme.onSurfaceVariant.withValues(alpha: 0.4)
                            : scheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(3),
            Text(
              stockText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: stockColor,
                fontSize: 10.5,
                fontWeight: product.isLowStock
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
