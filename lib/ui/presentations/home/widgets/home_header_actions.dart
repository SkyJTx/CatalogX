import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '/models/app_language.dart';
import '/state/catalog_notifier.dart';
import '/state/locale_notifier.dart';
import '/state/navigation_provider.dart';
import '/state/wishlist_notifier.dart';

class HomeHeaderActions extends ConsumerWidget {
  const HomeHeaderActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final currentLang = ref.watch(localeProvider);
    final isWishlistOnly = ref.watch(
      catalogProvider.select((s) => s.isWishlistOnly),
    );
    final wishlistCount = ref.watch(
      wishlistProvider.select((map) => map.length),
    );
    final cartCount = ref.watch(cartCountProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    LucideIcons.globe,
                    size: 13,
                    color: scheme.onSurface,
                  ),
                  const Gap(5),
                  Text(
                    currentLang == AppLanguage.th ? 'TH' : 'EN',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Gap(4),
        IconButton(
          onPressed: () {
            if (isWishlistOnly) {
              ref.read(catalogProvider.notifier).selectCategory(null);
            } else {
              ref.read(catalogProvider.notifier).selectWishlistOnly();
            }
          },
          icon: Badge(
            isLabelVisible: wishlistCount > 0,
            label: Text('$wishlistCount'),
            child: Icon(
              isWishlistOnly ? Icons.favorite_rounded : LucideIcons.heart,
              size: 19,
              color: isWishlistOnly ? scheme.error : scheme.onSurface,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            final messenger = ref.read(messengerServiceProvider);
            if (!messenger.isMessengerAvailable) {
              return;
            }
            messenger.messenger.clearSnackBars();
            messenger.showMessage(
              SnackBar(
                content: Text(
                  currentLang == AppLanguage.th
                      ? 'มีสินค้าในถุงช้อปปิ้ง $cartCount ชิ้น'
                      : '$cartCount item(s) in your shopping bag',
                ),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          icon: Badge(
            isLabelVisible: cartCount > 0,
            label: Text('$cartCount'),
            child: const Icon(LucideIcons.shoppingBag, size: 19),
          ),
        ),
        IconButton(
          onPressed: () {
            ref.read(navigatorServiceProvider).router.push('/settings');
          },
          icon: const Icon(LucideIcons.slidersHorizontal, size: 19),
        ),
        const Gap(6),
      ],
    );
  }
}
