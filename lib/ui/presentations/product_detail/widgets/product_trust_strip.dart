import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

import '/ui/localization/app_strings.dart';

class ProductTrustStrip extends StatelessWidget {
  final AppLocalization strings;

  const ProductTrustStrip({
    super.key,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: scheme.outlineVariant),
          bottom: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            Expanded(
              child: _TrustStripItem(
                icon: LucideIcons.shieldCheck,
                title: strings.trustAuthenticTitle,
                subtitle: strings.trustAuthenticSubtitle,
              ),
            ),
            VerticalDivider(color: scheme.outlineVariant, width: 16),
            Expanded(
              child: _TrustStripItem(
                icon: LucideIcons.truck,
                title: strings.trustInstallmentTitle,
                subtitle: strings.trustInstallmentSubtitle,
              ),
            ),
            VerticalDivider(color: scheme.outlineVariant, width: 16),
            Expanded(
              child: _TrustStripItem(
                icon: LucideIcons.rotateCcw,
                title: strings.trustReturnTitle,
                subtitle: strings.trustReturnSubtitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrustStripItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _TrustStripItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 18, color: scheme.onSurface),
        const Gap(6),
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(2),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelSmall?.copyWith(
            color: scheme.onSurfaceVariant,
            fontSize: 10.5,
          ),
        ),
      ],
    );
  }
}
