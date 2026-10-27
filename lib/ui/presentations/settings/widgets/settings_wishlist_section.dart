import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '/state/locale_notifier.dart';
import '/state/wishlist_notifier.dart';

class SettingsWishlistSection extends ConsumerWidget {
  const SettingsWishlistSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final strings = ref.watch(appStringsProvider);
    final wishlistCount = ref.watch(
      wishlistProvider.select((map) => map.length),
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            LucideIcons.database,
            size: 20,
            color: scheme.onSurface,
          ),
          const Gap(14),
          Expanded(
            child: Text(
              strings.wishlistStorageSummary(wishlistCount),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (wishlistCount > 0)
            TextButton(
              onPressed: () {
                ref.read(wishlistProvider.notifier).clearAll();
              },
              child: Text(
                strings.clearWishlistButton,
                style: TextStyle(
                  color: scheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
