import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '/models/app_language.dart';
import '/state/locale_notifier.dart';
import '/ui/presentations/settings/widgets/settings_option_tile.dart';

class SettingsLanguageSection extends ConsumerWidget {
  const SettingsLanguageSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentLang = ref.watch(localeProvider);
    final strings = ref.watch(appStringsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          strings.languageSectionTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(12),
        Row(
          children: <Widget>[
            Expanded(
              child: SettingsOptionTile(
                icon: LucideIcons.languages,
                label: strings.languageThaiLabel,
                isSelected: currentLang == AppLanguage.th,
                onTap: () {
                  ref
                      .read(localeProvider.notifier)
                      .setLanguage(AppLanguage.th);
                },
              ),
            ),
            const Gap(10),
            Expanded(
              child: SettingsOptionTile(
                icon: LucideIcons.globe,
                label: strings.languageEnglishLabel,
                isSelected: currentLang == AppLanguage.en,
                onTap: () {
                  ref
                      .read(localeProvider.notifier)
                      .setLanguage(AppLanguage.en);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
