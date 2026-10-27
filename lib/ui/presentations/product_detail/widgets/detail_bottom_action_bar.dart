import 'package:material_ui/material_ui.dart';

import '/models/product.dart';
import '/ui/localization/app_strings.dart';
import '/ui/presentations/product_detail/widgets/detail_action_buttons.dart';

class DetailBottomActionBar extends StatelessWidget {
  final Product product;
  final int quantity;
  final AppLocalization strings;

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
        color: scheme.surface,
        border: Border(
          top: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
