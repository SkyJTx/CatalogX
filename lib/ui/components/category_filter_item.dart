import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

class CategoryFilterItem extends StatelessWidget {
  final String label;
  final IconData? leadingIcon;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryFilterItem({
    super.key,
    required this.label,
    this.leadingIcon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: isSelected ? scheme.primary : scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (leadingIcon != null) ...<Widget>[
                Icon(
                  leadingIcon,
                  size: 13,
                  color: isSelected
                      ? scheme.onPrimary
                      : scheme.onSurfaceVariant,
                ),
                const Gap(6),
              ],
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isSelected ? scheme.onPrimary : scheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
