import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/state/catalog_notifier.dart';
import '/state/locale_notifier.dart';
import '/ui/presentations/home/widgets/catalog_sort_menu.dart';

class CatalogToolbar extends ConsumerWidget {
  const CatalogToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final strings = ref.watch(appStringsProvider);
    final loadedCount = ref.watch(
      catalogProvider.select((s) => s.products.length),
    );
    final totalCount = ref.watch(catalogProvider.select((s) => s.total));
    final selectedCategorySlug = ref.watch(
      catalogProvider.select((s) => s.selectedCategorySlug),
    );
    final isWishlistOnly = ref.watch(
      catalogProvider.select((s) => s.isWishlistOnly),
    );
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            strings.showingResultsCount(loadedCount, totalCount),
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (selectedCategorySlug != null || isWishlistOnly)
          TextButton(
            onPressed: () {
              ref.read(catalogProvider.notifier).resetFilters();
            },
            child: Text(strings.resetFiltersButton),
          ),
        if (isMobile) const CatalogSortMenu(),
      ],
    );
  }
}
