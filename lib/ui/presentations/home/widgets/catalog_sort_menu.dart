import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '/models/catalog_sort_option.dart';
import '/state/catalog_notifier.dart';
import '/state/locale_notifier.dart';

class CatalogSortMenu extends ConsumerWidget {
  const CatalogSortMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final sortOption = ref.watch(catalogProvider.select((s) => s.sortOption));
    final strings = ref.watch(appStringsProvider);

    return PopupMenuButton<CatalogSortOption>(
      initialValue: sortOption,
      onSelected: (option) {
        ref.read(catalogProvider.notifier).updateSort(option);
      },
      itemBuilder: (context) {
        return CatalogSortOption.values.map((option) {
          final isSelected = option == sortOption;
          return PopupMenuItem<CatalogSortOption>(
            value: option,
            child: Text(
              strings.sortLabel(option),
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              LucideIcons.arrowUpDown,
              size: 13,
              color: scheme.onSurface,
            ),
            const Gap(6),
            Text(
              strings.sortLabel(sortOption),
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
