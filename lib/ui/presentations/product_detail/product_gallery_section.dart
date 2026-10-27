import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '../../../models/product.dart';
import '../../../theme.dart';
import '../../localization/app_strings.dart';

class ProductGallerySection extends StatelessWidget {
  final Product product;
  final AppStrings strings;
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
    final isDark = theme.brightness == Brightness.dark;
    final images = product.galleryImages;
    final safeIndex = images.isEmpty
        ? 0
        : selectedIndex.clamp(0, images.length - 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: 6,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                product.brand,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              '• ${product.category} • SKU: ${product.sku}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const Gap(10),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.08,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: images.isEmpty
                            ? Center(
                                child: Icon(
                                  LucideIcons.package2,
                                  size: 56,
                                  color: scheme.onSurfaceVariant,
                                ),
                              )
                            : PageView.builder(
                                controller: pageController,
                                itemCount: images.length,
                                onPageChanged: onPageChanged,
                                itemBuilder: (context, index) {
                                  final imageUrl = images[index];
                                  final imageWidget = Image.network(
                                    imageUrl,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Icon(
                                          LucideIcons.package2,
                                          size: 56,
                                          color: scheme.onSurfaceVariant,
                                        ),
                                      );
                                    },
                                  );
                                  if (index == 0) {
                                    return Hero(
                                      tag: 'product-image-${product.id}',
                                      child: imageWidget,
                                    );
                                  }
                                  return imageWidget;
                                },
                              ),
                      ),
                      if (product.hasDiscount)
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppPalette.discountRoseBgDark
                                  : AppPalette.discountRoseBgLight,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              strings.discountPill(
                                product.discountPercentage.round(),
                              ),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppPalette.discountRose,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      if (images.isNotEmpty)
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.65),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '${safeIndex + 1} / ${images.length}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (images.length > 1) ...<Widget>[
                  const Gap(12),
                  SizedBox(
                    height: 58,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: images.length,
                      separatorBuilder: (context, index) => const Gap(8),
                      itemBuilder: (context, index) {
                        final isSelected = index == safeIndex;
                        return InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => onThumbnailTap(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 58,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: scheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? scheme.primary
                                    : scheme.outlineVariant,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Image.network(
                              images[index],
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  LucideIcons.image,
                                  size: 18,
                                  color: scheme.onSurfaceVariant,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (showTrustBadgesBelow) ...<Widget>[
          const Gap(14),
          TrustBadgesRow(strings: strings),
        ],
      ],
    );
  }
}

class TrustBadgesRow extends StatelessWidget {
  final AppStrings strings;

  const TrustBadgesRow({
    super.key,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _TrustBadgeCard(
            icon: LucideIcons.shieldCheck,
            title: strings.trustAuthenticTitle,
            subtitle: strings.trustAuthenticSubtitle,
          ),
        ),
        const Gap(10),
        Expanded(
          child: _TrustBadgeCard(
            icon: LucideIcons.truck,
            title: strings.trustInstallmentTitle,
            subtitle: strings.trustInstallmentSubtitle,
          ),
        ),
        const Gap(10),
        Expanded(
          child: _TrustBadgeCard(
            icon: LucideIcons.rotateCcw,
            title: strings.trustReturnTitle,
            subtitle: strings.trustReturnSubtitle,
          ),
        ),
      ],
    );
  }
}

class _TrustBadgeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _TrustBadgeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Column(
          children: <Widget>[
            Icon(icon, size: 20, color: scheme.primary),
            const Gap(6),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const Gap(2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}