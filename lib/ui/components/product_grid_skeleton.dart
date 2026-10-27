import 'package:material_ui/material_ui.dart';

import '/ui/components/skeleton_product_tile.dart';

class ProductGridSkeleton extends StatefulWidget {
  final int crossAxisCount;
  final double childAspectRatio;
  final double spacing;

  const ProductGridSkeleton({
    super.key,
    required this.crossAxisCount,
    required this.childAspectRatio,
    required this.spacing,
  });

  @override
  State<ProductGridSkeleton> createState() => _ProductGridSkeletonState();
}

class _ProductGridSkeletonState extends State<ProductGridSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final itemCount = widget.crossAxisCount * 3;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final alpha = 0.45 + (_controller.value * 0.4);
        final barColor =
            scheme.surfaceContainerHighest.withValues(alpha: alpha);

        return SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.crossAxisCount,
            mainAxisSpacing: widget.spacing,
            crossAxisSpacing: widget.spacing,
            childAspectRatio: widget.childAspectRatio,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => SkeletonProductTile(baseColor: barColor),
            childCount: itemCount,
          ),
        );
      },
    );
  }
}
