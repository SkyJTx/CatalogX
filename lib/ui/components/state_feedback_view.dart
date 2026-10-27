import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

class StateFeedbackView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;
  final bool isError;

  const StateFeedbackView({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
    this.isError = false,
  });

  factory StateFeedbackView.error({
    Key? key,
    required String title,
    required String message,
    required String retryLabel,
    required VoidCallback onRetry,
  }) {
    return StateFeedbackView(
      key: key,
      icon: LucideIcons.wifiOff,
      title: title,
      subtitle: message,
      actionLabel: retryLabel,
      onAction: onRetry,
      isError: true,
    );
  }

  factory StateFeedbackView.empty({
    Key? key,
    required String title,
    required String subtitle,
    required String resetLabel,
    required VoidCallback onReset,
  }) {
    return StateFeedbackView(
      key: key,
      icon: LucideIcons.packageSearch,
      title: title,
      subtitle: subtitle,
      actionLabel: resetLabel,
      onAction: onReset,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accentColor = isError ? scheme.error : scheme.primary;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 30,
                    color: accentColor,
                  ),
                ),
                const Gap(16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                const Gap(20),
                FilledButton.icon(
                  onPressed: onAction,
                  icon: Icon(
                    isError ? LucideIcons.refreshCw : LucideIcons.rotateCcw,
                    size: 16,
                  ),
                  label: Text(actionLabel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}