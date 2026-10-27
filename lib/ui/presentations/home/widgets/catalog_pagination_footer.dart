import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '/state/catalog_notifier.dart';
import '/state/locale_notifier.dart';

class CatalogPaginationFooter extends ConsumerWidget {
  const CatalogPaginationFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final state = ref.watch(catalogProvider);
    final currentLang = ref.watch(localeProvider);
    final strings = ref.watch(appStringsProvider);

    return Column(
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Column(
            children: <Widget>[
              Text(
                strings.pageProgressText(
                  currentPage: state.currentPage,
                  totalPages: state.totalPages,
                  loaded: state.products.length,
                  total: state.total,
                ),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const Gap(10),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: state.loadProgress,
                  minHeight: 3,
                  backgroundColor: scheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(scheme.onSurface),
                ),
              ),
            ],
          ),
        ),
        const Gap(18),
        if (state.loadMoreError != null) ...<Widget>[
          Text(
            state.loadMoreError!.localizedMessage(currentLang),
            style: TextStyle(color: scheme.error, fontSize: 12.5),
          ),
          const Gap(8),
        ],
        if (state.hasMore)
          OutlinedButton.icon(
            onPressed: state.isLoadingMore
                ? null
                : () {
                    ref.read(catalogProvider.notifier).loadMore();
                  },
            icon: state.isLoadingMore
                ? const SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(LucideIcons.plus, size: 15),
            label: Text(
              state.isLoadingMore
                  ? strings.loadingMoreButton
                  : strings.loadMoreButton,
            ),
          )
        else
          Text(
            strings.allProductsLoaded,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}
