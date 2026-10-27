import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '/models/product.dart';
import '/ui/localization/app_strings.dart';

class ProductHeaderSection extends StatelessWidget {
  final Product product;
  final AppLocalization strings;

  const ProductHeaderSection({
    super.key,
    required this.product,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final stockText = product.isOutOfStock
        ? strings.outOfStockBadge
        : (product.isLowStock
            ? strings.lowStockBadge(product.stock)
            : strings.inStockBadge(product.stock));
    final stockColor = product.isOutOfStock || product.isLowStock
        ? scheme.error
        : scheme.tertiary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          product.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            height: 1.25,
            letterSpacing: -0.3,
          ),
        ),
        const Gap(10),
        Wrap(
          spacing: 16,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: scheme.secondary,
                ),
                const Gap(4),
                Text(
                  product.rating.toStringAsFixed(1),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
                const Gap(4),
                Text(
                  '(${strings.reviewsCountLabel(product.reviews.length)})',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  LucideIcons.shieldCheck,
                  size: 14,
                  color: scheme.onSurfaceVariant,
                ),
                const Gap(5),
                Text(
                  product.warrantyInformation,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Gap(18),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 12,
          runSpacing: 6,
          children: <Widget>[
            Text(
              strings.formatPrice(product.price),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
              ),
            ),
            if (product.hasDiscount) ...<Widget>[
              Text(
                strings.formatPrice(product.originalPrice),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              Text(
                strings.saveBadge(strings.formatPrice(product.savingsAmount)),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        const Gap(12),
        Wrap(
          spacing: 16,
          runSpacing: 6,
          children: <Widget>[
            Text(
              stockText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: stockColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  LucideIcons.truck,
                  size: 14,
                  color: scheme.onSurfaceVariant,
                ),
                const Gap(5),
                Text(
                  product.shippingInformation,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
