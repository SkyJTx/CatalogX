import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '/models/product.dart';
import '/ui/localization/app_strings.dart';
import '/ui/presentations/product_detail/widgets/product_gallery_thumbnails.dart';
import '/ui/presentations/product_detail/widgets/product_trust_strip.dart';

class ProductGallerySection extends StatelessWidget {
  final Product product;
  final AppLocalization strings;
  final PageController pageController;
  final int selectedIndex;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onThumbnailTap;
  final bool showTrustBadgesBelow;

  const ProductGallerySection({
    super.key,
    required this.product,
    required this.strings,
    required this.pageController,
    required this.selectedIndex,
    required this.onPageChanged,
    required this.onThumbnailTap,
    required this.showTrustBadgesBelow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final images = product.galleryImages;
    final discountPercent = product.discountPercentage.round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              product.brand.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            const Gap(8),
            Expanded(
              child: Text(
                '${product.category}  |  SKU ${product.sku}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const Gap(12),
        AspectRatio(
          aspectRatio: 1.08,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                if (images.isEmpty)
                  Center(
                    child: Icon(
                      LucideIcons.package,
                      size: 56,
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                  )
                else
                  PageView.builder(
                    controller: pageController,
                    itemCount: images.length,
                    onPageChanged: onPageChanged,
                    itemBuilder: (context, index) {
                      final imageWidget = Image.network(
                        images[index],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              LucideIcons.imageOff,
                              size: 48,
                              color: scheme.onSurfaceVariant,
                            ),
                          );
                        },
                      );
                      return Padding(
                        padding: const EdgeInsets.all(24),
                        child: index == 0
                            ? Hero(
                                tag: 'product_image_${product.id}',
                                child: imageWidget,
                              )
                            : imageWidget,
                      );
                    },
                  ),
                if (product.hasDiscount)
                  Positioned(
                    top: 14,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: scheme.surface.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        strings.discountPill(discountPercent),
                        style: TextStyle(
                          color: scheme.error,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                if (images.length > 1)
                  Positioned(
                    bottom: 12,
                    right: 14,
                    child: Text(
                      '${selectedIndex + 1} / ${images.length}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (images.length > 1) ...<Widget>[
          const Gap(12),
          ProductGalleryThumbnails(
            images: images,
            selectedIndex: selectedIndex,
            onThumbnailTap: onThumbnailTap,
          ),
        ],
        if (showTrustBadgesBelow) ...<Widget>[
          const Gap(20),
          ProductTrustStrip(strings: strings),
        ],
      ],
    );
  }
}
