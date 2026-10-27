import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/state/locale_notifier.dart';
import '/ui/presentations/home/widgets/home_header_actions.dart';

class HomeAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(62);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final strings = ref.watch(appStringsProvider);
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return AppBar(
      toolbarHeight: 61,
      titleSpacing: isMobile ? 16 : 24,
      title: Row(
        children: <Widget>[
          Icon(
            LucideIcons.sparkles,
            size: 18,
            color: scheme.onSurface,
          ),
          const Gap(10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  strings.appTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                if (!isMobile)
                  Text(
                    strings.appSubtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      actions: const <Widget>[
        HomeHeaderActions(),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(color: scheme.outlineVariant, height: 1),
      ),
    );
  }
}
