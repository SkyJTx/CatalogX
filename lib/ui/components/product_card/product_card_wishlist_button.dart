import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '/models/product.dart';
import '/state/wishlist_notifier.dart';

class ProductCardWishlistButton extends ConsumerWidget {
  final Product product;

  const ProductCardWishlistButton({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isWishlisted = ref.watch(
      wishlistProvider.select((map) => map.containsKey(product.id)),
    );
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surface.withValues(alpha: 0.86),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          ref.read(wishlistProvider.notifier).toggle(product);
        },
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Icon(
            isWishlisted ? Icons.favorite_rounded : LucideIcons.heart,
            size: 16,
            color: isWishlisted ? scheme.error : scheme.onSurface,
          ),
        ),
      ),
    );
  }
}
