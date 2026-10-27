import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '/models/product.dart';
import '/ui/localization/app_strings.dart';
import '/ui/presentations/product_detail/widgets/detail_action_buttons.dart';

class ProductPurchaseSection extends StatelessWidget {
  final Product product;
  final AppLocalization strings;
  final int quantity;
  final bool showInlineActionButtons;
  final ValueChanged<int> onQuantityChanged;

  const ProductPurchaseSection({
    super.key,
    required this.product,
    required this.strings,
    required this.quantity,
    required this.showInlineActionButtons,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                strings.quantityLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: quantity > 1
                        ? () => onQuantityChanged(quantity - 1)
                        : null,
                    icon: const Icon(LucideIcons.minus, size: 15),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '$quantity',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: quantity < product.stock
                        ? () => onQuantityChanged(quantity + 1)
                        : null,
                    icon: const Icon(LucideIcons.plus, size: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (showInlineActionButtons) ...<Widget>[
          const Gap(18),
          DetailActionButtons(
            product: product,
            quantity: quantity,
            strings: strings,
          ),
        ],
      ],
    );
  }
}
