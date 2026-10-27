import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';

class ProductGalleryThumbnails extends StatelessWidget {
  final List<String> images;
  final int selectedIndex;
  final ValueChanged<int> onThumbnailTap;

  const ProductGalleryThumbnails({
    super.key,
    required this.images,
    required this.selectedIndex,
    required this.onThumbnailTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 68,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (context, index) => const Gap(10),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onThumbnailTap(index),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: isSelected ? 1.0 : 0.55,
              child: Container(
                width: 68,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                  border: isSelected
                      ? Border.all(color: scheme.onSurface, width: 1.5)
                      : null,
                ),
                child: Image.network(
                  images[index],
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      LucideIcons.image,
                      size: 18,
                      color: scheme.onSurfaceVariant,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
