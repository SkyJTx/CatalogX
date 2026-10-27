import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '/models/product_category.dart';
import '/state/catalog_notifier.dart';
import '/state/locale_notifier.dart';
import '/state/product_detail_provider.dart';
import '/state/wishlist_notifier.dart';
import '/theme.dart';

class CategoryFilterBar extends ConsumerWidget {
  const CategoryFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final wishlistCount = ref.watch(
      wishlistProvider.select((items) => items.length),
    );
    final strings = ref.watch(appStringsProvider);

    final categories = categoriesAsync.value ?? const <ProductCategory>[];
    final isAllSelected = !catalogState.isWishlistOnly &&
        catalogState.selectedCategorySlug == null;

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _CategoryPill(
            label: strings.allCategoriesLabel,
            isSelected: isAllSelected,
            onTap: () {
              ref.read(catalogProvider.notifier).selectCategory(null);
            },
          ),
          const Gap(8),
          _CategoryPill(
            label: strings.wishlistFilterLabel(wishlistCount),
            icon: catalogState.isWishlistOnly
                ? Icons.favorite
                : LucideIcons.heart,
            iconColor: catalogState.isWishlistOnly
                ? Colors.white
                : AppPalette.discountRose,
            isSelected: catalogState.isWishlistOnly,
            onTap: () {
              ref.read(catalogProvider.notifier).selectWishlistOnly();
            },
          ),
          for (final category in categories) ...<Widget>[
            const Gap(8),
            _CategoryPill(
              label: category.name,
              isSelected: !catalogState.isWishlistOnly &&
                  catalogState.selectedCategorySlug == category.slug,
              onTap: () {
                ref
                    .read(catalogProvider.notifier)
                    .selectCategory(category.slug);
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryPill({
    required this.label,
    this.icon,
    this.iconColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: isSelected ? scheme.primary : scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(999),
        side: BorderSide(
          color: isSelected ? scheme.primary : scheme.outlineVariant,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (icon != null) ...<Widget>[
                Icon(
                  icon,
                  size: 15,
                  color: iconColor ??
                      (isSelected ? Colors.white : scheme.onSurfaceVariant),
                ),
                const Gap(6),
              ],
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isSelected ? Colors.white : scheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}