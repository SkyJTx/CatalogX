import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '/models/product.dart';
import '/state/wishlist_notifier.dart';
import '/ui/localization/app_strings.dart';

class DetailActionButtons extends ConsumerWidget {
  final Product product;
  final int quantity;
  final AppLocalization strings;

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
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              ref.read(wishlistProvider.notifier).toggle(product);
            },
            child: SizedBox(
              width: 48,
              height: 48,
              child: Icon(
                isWishlisted ? Icons.favorite_rounded : LucideIcons.heart,
                size: 19,
                color: isWishlisted ? scheme.error : scheme.onSurface,
              ),
            ),
          ),
        ),
        const Gap(10),
        Expanded(
          child: SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              onPressed: product.isOutOfStock
                  ? null
                  : () {
                      ref
                          .read(cartCountProvider.notifier)
                          .addItems(product, quantity: quantity);
                    },
              icon: const Icon(LucideIcons.shoppingBag, size: 16),
              label: Text(
                strings.addToCartButton,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        const Gap(10),
        Expanded(
          child: SizedBox(
            height: 48,
            child: FilledButton.icon(
              onPressed: product.isOutOfStock
                  ? null
                  : () {
                      ref
                          .read(cartCountProvider.notifier)
                          .addItems(product, quantity: quantity);
                    },
              icon: const Icon(LucideIcons.zap, size: 16),
              label: Text(
                strings.buyNowButton,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
