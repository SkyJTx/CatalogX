import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '/models/product.dart';
import '/state/locale_notifier.dart';
import '/state/navigation_provider.dart';
import '/ui/components/product_card/product_card_info.dart';
import '/ui/components/product_card/product_card_media.dart';

class ProductCard extends ConsumerWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        ref.read(navigatorServiceProvider).router.push(
              '/products/${product.id}',
              extra: product,
            );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 12,
            child: ProductCardMedia(
              product: product,
              strings: strings,
            ),
          ),
          const Gap(10),
          Expanded(
            flex: 9,
            child: ProductCardInfo(
              product: product,
              strings: strings,
            ),
          ),
        ],
      ),
    );
  }
}
