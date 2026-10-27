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
    bool isWishlist = false,
  }) {
    return StateFeedbackView(
      key: key,
      icon: isWishlist ? LucideIcons.heart : LucideIcons.searchX,
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

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: isError ? scheme.error : scheme.onSurface,
                ),
              ),
              const Gap(20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const Gap(24),
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
    );
  }
}
