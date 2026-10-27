import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

class ProductSpecsList extends StatelessWidget {
  final List<({String label, String value})> entries;

  const ProductSpecsList({
    super.key,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      children: <Widget>[
        for (int i = 0; i < entries.length; i++) ...<Widget>[
          if (i > 0) Divider(color: scheme.outlineVariant, height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Text(
                    entries[i].label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const Gap(12),
                Expanded(
                  flex: 3,
                  child: Text(
                    entries[i].value,
                    textAlign: TextAlign.right,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
