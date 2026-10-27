import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '/models/app_language.dart';
import '/state/locale_notifier.dart';
import '/state/theme_notifier.dart';
import '/state/wishlist_notifier.dart';

class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const SettingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final themeMode = ref.watch(themeModeProvider);
    final currentLang = ref.watch(localeProvider);
    final strings = ref.watch(appStringsProvider);
    final wishlistCount = ref.watch(
      wishlistProvider.select((map) => map.length),
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: scheme.outlineVariant,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const Gap(16),
              Row(
                children: <Widget>[
                  Icon(LucideIcons.slidersHorizontal, color: scheme.primary),
                  const Gap(10),
                  Expanded(
                    child: Text(
                      strings.settingsSheetTitle,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(LucideIcons.x, size: 18),
                  ),
                ],
              ),
              const Gap(16),
              Text(
                strings.themeSectionTitle,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Gap(10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _OptionTile(
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
                  const Gap(8),
                  Expanded(
                    child: _OptionTile(
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
                  const Gap(8),
                  Expanded(
                    child: _OptionTile(
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
              const Gap(20),
              Text(
                strings.languageSectionTitle,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Gap(10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _OptionTile(
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
                    child: _OptionTile(
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
              const Gap(20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      LucideIcons.database,
                      size: 18,
                      color: scheme.primary,
                    ),
                    const Gap(10),
                    Expanded(
                      child: Text(
                        strings.wishlistStorageSummary(wishlistCount),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (wishlistCount > 0)
                      TextButton(
                        onPressed: () {
                          ref.read(wishlistProvider.notifier).clearAll();
                        },
                        child: Text(strings.clearWishlistButton),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: isSelected
          ? scheme.primary.withValues(alpha: 0.12)
          : scheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isSelected ? scheme.primary : scheme.outlineVariant,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            children: <Widget>[
              Icon(
                icon,
                size: 20,
                color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
              ),
              const Gap(6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected ? scheme.primary : scheme.onSurface,
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