import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '/models/product.dart';
import '/ui/components/product_card/product_card_wishlist_button.dart';
import '/ui/localization/app_strings.dart';

class ProductCardMedia extends StatelessWidget {
  final Product product;
  final AppLocalization strings;

  const ProductCardMedia({
    super.key,
    required this.product,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final discountPercent = product.discountPercentage.round();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(14),
            child: Hero(
              tag: 'product_image_${product.id}',
              child: Image.network(
                product.thumbnail,
                fit: BoxFit.contain,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) {
                    return child;
                  }
                  return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    child: child,
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      LucideIcons.package,
                      size: 32,
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.45),
                    ),
                  );
                },
              ),
            ),
          ),
          if (product.hasDiscount)
            Positioned(
              left: 10,
              bottom: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: scheme.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  strings.discountPill(discountPercent),
                  style: TextStyle(
                    color: scheme.error,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ),
          Positioned(
            top: 8,
            right: 8,
            child: ProductCardWishlistButton(product: product),
          ),
        ],
      ),
    );
  }
}
