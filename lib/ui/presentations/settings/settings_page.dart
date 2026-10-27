import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/state/locale_notifier.dart';
import '/state/navigation_provider.dart';
import '/ui/presentations/settings/widgets/settings_language_section.dart';
import '/ui/presentations/settings/widgets/settings_theme_section.dart';
import '/ui/presentations/settings/widgets/settings_wishlist_section.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
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
        title: Text(strings.settingsSheetTitle),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: scheme.outlineVariant, height: 1),
        ),
      ),
      body: MaxWidthBox(
        maxWidth: 680,
        backgroundColor: scheme.surface,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          children: const <Widget>[
            SettingsThemeSection(),
            Gap(28),
            Divider(height: 1),
            Gap(28),
            SettingsLanguageSection(),
            Gap(28),
            Divider(height: 1),
            Gap(28),
            SettingsWishlistSection(),
          ],
        ),
      ),
    );
  }
}
