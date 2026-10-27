import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

import '/models/product_review.dart';
import '/ui/localization/app_strings.dart';

class ProductReviewsList extends StatelessWidget {
  final List<ProductReview> reviews;
  final AppLocalization strings;

  const ProductReviewsList({
    super.key,
    required this.reviews,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (reviews.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          strings.noReviewsMessage,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Column(
      children: <Widget>[
        for (int i = 0; i < reviews.length; i++) ...<Widget>[
          if (i > 0) Divider(color: scheme.outlineVariant, height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        reviews[i].reviewerName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List<Widget>.generate(5, (starIndex) {
                        return Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: starIndex < reviews[i].rating
                              ? scheme.secondary
                              : scheme.outlineVariant,
                        );
                      }),
                    ),
                  ],
                ),
                const Gap(6),
                Text(
                  reviews[i].comment,
                  style: theme.textTheme.bodyMedium,
                ),
                const Gap(4),
                Text(
                  strings.formatDate(reviews[i].date),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
