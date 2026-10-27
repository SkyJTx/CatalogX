import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../models/catalog_filter.dart';
import '../../state/catalog_notifier.dart';
import '../../state/locale_notifier.dart';

class CatalogSearchBar extends ConsumerStatefulWidget {
  const CatalogSearchBar({super.key});

  @override
  ConsumerState<CatalogSearchBar> createState() => _CatalogSearchBarState();
}

class _CatalogSearchBarState extends ConsumerState<CatalogSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(catalogProvider).searchQuery,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final strings = ref.watch(appStringsProvider);
    final catalogState = ref.watch(catalogProvider);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    if (_controller.text != catalogState.searchQuery &&
        catalogState.searchQuery.isEmpty) {
      _controller.clear();
    }

    final searchField = TextField(
      controller: _controller,
      onChanged: (value) {
        ref.read(catalogProvider.notifier).updateSearchQuery(value);
      },
      onSubmitted: (value) {
        ref.read(catalogProvider.notifier).submitSearchImmediately(value);
      },
      decoration: InputDecoration(
        hintText: strings.searchHint,
        prefixIcon: Icon(
          LucideIcons.search,
          size: 18,
          color: scheme.onSurfaceVariant,
        ),
        suffixIcon: catalogState.searchQuery.isNotEmpty
            ? IconButton(
                onPressed: () {
                  _controller.clear();
                  ref.read(catalogProvider.notifier).submitSearchImmediately('');
                },
                icon: Icon(
                  LucideIcons.x,
                  size: 16,
                  color: scheme.onSurfaceVariant,
                ),
              )
            : null,
      ),
    );

    final sortSelector = PopupMenuButton<CatalogSortOption>(
      initialValue: catalogState.sortOption,
      onSelected: (option) {
        ref.read(catalogProvider.notifier).updateSort(option);
      },
      itemBuilder: (context) {
        return CatalogSortOption.values.map((option) {
          final isSelected = option == catalogState.sortOption;
          return PopupMenuItem<CatalogSortOption>(
            value: option,
            child: Row(
              children: <Widget>[
                Icon(
                  isSelected ? LucideIcons.check : LucideIcons.arrowUpDown,
                  size: 16,
                  color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
                ),
                const Gap(8),
                Text(
                  strings.sortLabel(option),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? scheme.primary : scheme.onSurface,
                  ),
                ),
              ],
            ),
          );
        }).toList(growable: false);
      },
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              LucideIcons.slidersHorizontal,
              size: 16,
              color: scheme.primary,
            ),
            const Gap(8),
            Text(
              strings.sortLabel(catalogState.sortOption),
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(4),
            Icon(
              LucideIcons.chevronDown,
              size: 16,
              color: scheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );

    return ResponsiveRowColumn(
      layout: isMobile
          ? ResponsiveRowColumnType.COLUMN
          : ResponsiveRowColumnType.ROW,
      rowSpacing: 12,
      columnSpacing: 10,
      columnCrossAxisAlignment: CrossAxisAlignment.stretch,
      children: <ResponsiveRowColumnItem>[
        ResponsiveRowColumnItem(
          rowFlex: 1,
          rowFit: FlexFit.tight,
          child: searchField,
        ),
        if (!isMobile)
          ResponsiveRowColumnItem(
            child: sortSelector,
          ),
      ],
    );
  }
}