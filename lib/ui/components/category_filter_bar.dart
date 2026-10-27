import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '/models/product_category.dart';
import '/state/catalog_notifier.dart';
import '/state/locale_notifier.dart';
import '/state/product_detail_provider.dart';
import '/state/wishlist_notifier.dart';
import '/ui/components/category_filter_item.dart';

class CategoryFilterBar extends ConsumerWidget {
  const CategoryFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSlug = ref.watch(
      catalogProvider.select((s) => s.selectedCategorySlug),
    );
    final isWishlistOnly = ref.watch(
      catalogProvider.select((s) => s.isWishlistOnly),
    );
    final categoriesAsync = ref.watch(categoriesProvider);
    final wishlistCount = ref.watch(
      wishlistProvider.select((items) => items.length),
    );
    final strings = ref.watch(appStringsProvider);
    final categories = categoriesAsync.value ?? const <ProductCategory>[];

    final isAllSelected = !isWishlistOnly && selectedSlug == null;

    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          CategoryFilterItem(
            label: strings.allCategoriesLabel,
            isSelected: isAllSelected,
            onTap: () {
              ref.read(catalogProvider.notifier).selectCategory(null);
            },
          ),
          const Gap(8),
          CategoryFilterItem(
            label: strings.wishlistFilterLabel(wishlistCount),
            leadingIcon: isWishlistOnly
                ? Icons.favorite_rounded
                : LucideIcons.heart,
            isSelected: isWishlistOnly,
            onTap: () {
              ref.read(catalogProvider.notifier).selectWishlistOnly();
            },
          ),
          for (final category in categories) ...<Widget>[
            const Gap(8),
            CategoryFilterItem(
              label: category.name,
              isSelected:
                  !isWishlistOnly && selectedSlug == category.slug,
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
