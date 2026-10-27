import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '/models/app_language.dart';
import '/models/product.dart';
import '/state/locale_notifier.dart';
import '/state/navigation_provider.dart';
import '/state/wishlist_notifier.dart';

class ProductDetailAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final Product? product;

  const ProductDetailAppBar({
    super.key,
    required this.product,
  });

  @override
  Size get preferredSize => const Size.fromHeight(57);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final currentLang = ref.watch(localeProvider);
    final strings = ref.watch(appStringsProvider);
    final activeProduct = product;
    final isWishlisted = activeProduct != null &&
        ref.watch(
          wishlistProvider.select((map) => map.containsKey(activeProduct.id)),
        );

    return AppBar(
      leading: IconButton(
        onPressed: () {
          final router = ref.read(navigatorServiceProvider).router;
          if (router.canPop()) {
            router.pop();
          } else {
            router.go('/');
          }
        },
        icon: const Icon(LucideIcons.arrowLeft, size: 20),
      ),
      title: Text(
        strings.productDetailsTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: <Widget>[
        Material(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              ref.read(localeProvider.notifier).toggleLanguage();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(
                currentLang == AppLanguage.th ? 'TH' : 'EN',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                ),
              ),
            ),
          ),
        ),
        const Gap(6),
        if (activeProduct != null)
          IconButton(
            onPressed: () {
              ref.read(wishlistProvider.notifier).toggle(activeProduct);
            },
            icon: Icon(
              isWishlisted ? Icons.favorite_rounded : LucideIcons.heart,
              size: 20,
              color: isWishlisted ? scheme.error : scheme.onSurface,
            ),
          ),
        IconButton(
          onPressed: () {
            ref.read(navigatorServiceProvider).router.push('/settings');
          },
          icon: const Icon(LucideIcons.slidersHorizontal, size: 19),
        ),
        const Gap(8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(color: scheme.outlineVariant, height: 1),
      ),
    );
  }
}
