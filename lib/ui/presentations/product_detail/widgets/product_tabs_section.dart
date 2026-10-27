import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '/models/product.dart';
import '/ui/localization/app_strings.dart';
import '/ui/presentations/product_detail/widgets/product_reviews_list.dart';
import '/ui/presentations/product_detail/widgets/product_specs_list.dart';

class ProductTabsSection extends StatelessWidget {
  final Product product;
  final AppLocalization strings;
  final int selectedTabIndex;
  final ValueChanged<int> onTabSelected;

  const ProductTabsSection({
    super.key,
    required this.product,
    required this.strings,
    required this.selectedTabIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tabLabels = <String>[
      strings.tabOverview,
      strings.tabShippingAndReturns,
      strings.tabReviews(product.reviews.length),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            for (int index = 0; index < tabLabels.length; index++)
              Expanded(
                child: InkWell(
                  onTap: () => onTabSelected(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selectedTabIndex == index
                              ? scheme.onSurface
                              : scheme.outlineVariant,
                          width: selectedTabIndex == index ? 2 : 1,
                        ),
                      ),
                    ),
                    child: Text(
                      tabLabels[index],
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: selectedTabIndex == index
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: selectedTabIndex == index
                            ? scheme.onSurface
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        const Gap(18),
        if (selectedTabIndex == 0) ...<Widget>[
          Text(
            product.description,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
          ),
          const Gap(18),
          ProductSpecsList(
            entries: <({String label, String value})>[
              (
                label: strings.specDimensionsTitle,
                value:
                    '${product.dimensions.formatted} · ${strings.specWeightValue(product.weight)}',
              ),
              (
                label: strings.specSkuTitle,
                value:
                    '${product.sku} · ${strings.specMinOrderValue(product.minimumOrderQuantity)}',
              ),
            ],
          ),
        ] else if (selectedTabIndex == 1)
          ProductSpecsList(
            entries: <({String label, String value})>[
              (
                label: strings.specWarrantyTitle,
                value: product.warrantyInformation,
              ),
              (
                label: strings.specShippingTitle,
                value: product.shippingInformation,
              ),
              (
                label: strings.specReturnPolicyTitle,
                value: product.returnPolicy,
              ),
              if (product.meta.barcode.isNotEmpty)
                (
                  label: strings.specBarcodeTitle,
                  value: product.meta.barcode,
                ),
            ],
          )
        else
          ProductReviewsList(
            reviews: product.reviews,
            strings: strings,
          ),
      ],
    );
  }
}
