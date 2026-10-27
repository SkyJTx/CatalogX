import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/models/catalog_sort_option.dart';
import '/state/catalog_notifier.dart';
import '/state/locale_notifier.dart';

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
    final searchQuery = ref.watch(catalogProvider.select((s) => s.searchQuery));
    final sortOption = ref.watch(catalogProvider.select((s) => s.sortOption));

    if (_controller.text != searchQuery &&
        !FocusScope.of(context).hasFocus) {
      _controller.text = searchQuery;
    }

    final isWide = ResponsiveBreakpoints.of(context).largerThan(MOBILE);

    final searchField = TextField(
      controller: _controller,
      onChanged: (value) {
        setState(() {});
        ref.read(catalogProvider.notifier).updateSearchQuery(value);
      },
      onSubmitted: (value) {
        ref.read(catalogProvider.notifier).submitSearchImmediately(value);
      },
      textInputAction: TextInputAction.search,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: strings.searchHint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        prefixIcon: Icon(
          LucideIcons.search,
          size: 17,
          color: scheme.onSurfaceVariant,
        ),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  _controller.clear();
                  setState(() {});
                  ref
                      .read(catalogProvider.notifier)
                      .submitSearchImmediately('');
                },
                icon: Icon(
                  LucideIcons.x,
                  size: 15,
                  color: scheme.onSurfaceVariant,
                ),
              )
            : null,
      ),
    );

    if (!isWide) {
      return searchField;
    }

    return Row(
      children: <Widget>[
        Expanded(child: searchField),
        const Gap(12),
        PopupMenuButton<CatalogSortOption>(
          initialValue: sortOption,
          onSelected: (option) {
            ref.read(catalogProvider.notifier).updateSort(option);
          },
          itemBuilder: (context) {
            return CatalogSortOption.values.map((option) {
              final selected = option == sortOption;
              return PopupMenuItem<CatalogSortOption>(
                value: option,
                child: Row(
                  children: <Widget>[
                    Icon(
                      selected
                          ? LucideIcons.check
                          : LucideIcons.arrowUpDown,
                      size: 15,
                      color: selected
                          ? scheme.onSurface
                          : scheme.onSurfaceVariant,
                    ),
                    const Gap(10),
                    Text(
                      strings.sortLabel(option),
                      style: TextStyle(
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            }).toList();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  LucideIcons.slidersHorizontal,
                  size: 15,
                  color: scheme.onSurface,
                ),
                const Gap(8),
                Text(
                  strings.sortLabel(sortOption),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(6),
                Icon(
                  LucideIcons.chevronDown,
                  size: 15,
                  color: scheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
