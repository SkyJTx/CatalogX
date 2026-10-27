import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '/state/locale_notifier.dart';
import '/state/theme_notifier.dart';
import '/ui/presentations/settings/widgets/settings_option_tile.dart';

class SettingsThemeSection extends ConsumerWidget {
  const SettingsThemeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final strings = ref.watch(appStringsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          strings.themeSectionTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(12),
        Row(
          children: <Widget>[
            Expanded(
              child: SettingsOptionTile(
                icon: LucideIcons.sun,
                label: strings.themeLightLabel,
                isSelected: themeMode == ThemeMode.light,
                onTap: () {
                  ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.light);
                },
              ),
            ),
            const Gap(10),
            Expanded(
              child: SettingsOptionTile(
                icon: LucideIcons.moon,
                label: strings.themeDarkLabel,
                isSelected: themeMode == ThemeMode.dark,
                onTap: () {
                  ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.dark);
                },
              ),
            ),
            const Gap(10),
            Expanded(
              child: SettingsOptionTile(
                icon: LucideIcons.monitor,
                label: strings.themeSystemLabel,
                isSelected: themeMode == ThemeMode.system,
                onTap: () {
                  ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(ThemeMode.system);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
