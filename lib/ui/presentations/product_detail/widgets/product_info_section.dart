import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '/models/product.dart';
import '/ui/localization/app_strings.dart';
import '/ui/presentations/product_detail/widgets/product_header_section.dart';
import '/ui/presentations/product_detail/widgets/product_purchase_section.dart';
import '/ui/presentations/product_detail/widgets/product_tabs_section.dart';
import '/ui/presentations/product_detail/widgets/product_trust_strip.dart';

class ProductInfoSection extends StatelessWidget {
  final Product product;
  final AppLocalization strings;
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
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ProductHeaderSection(
          product: product,
          strings: strings,
        ),
        const Gap(20),
        Divider(color: scheme.outlineVariant, height: 1),
        const Gap(20),
        ProductPurchaseSection(
          product: product,
          strings: strings,
          quantity: quantity,
          showInlineActionButtons: showInlineActionButtons,
          onQuantityChanged: onQuantityChanged,
        ),
        const Gap(24),
        ProductTabsSection(
          product: product,
          strings: strings,
          selectedTabIndex: selectedTabIndex,
          onTabSelected: onTabSelected,
        ),
        if (showBottomTrustBadges) ...<Widget>[
          const Gap(24),
          ProductTrustStrip(strings: strings),
        ],
      ],
    );
  }
}
