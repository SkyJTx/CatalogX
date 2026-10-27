import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

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
      duration: const Duration(milliseconds: 1300),
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
        final pulseOpacity = 0.45 + (_controller.value * 0.4);
        final blockColor = scheme.surfaceContainerHighest.withValues(
          alpha: pulseOpacity,
        );

        return SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.crossAxisCount,
            mainAxisSpacing: widget.spacing,
            crossAxisSpacing: widget.spacing,
            childAspectRatio: widget.childAspectRatio,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 11,
                        child: Container(
                          decoration: BoxDecoration(
                            color: blockColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        flex: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                _SkeletonBar(
                                  width: 64,
                                  height: 14,
                                  color: blockColor,
                                ),
                                _SkeletonBar(
                                  width: 36,
                                  height: 14,
                                  color: blockColor,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _SkeletonBar(
                                  width: double.infinity,
                                  height: 14,
                                  color: blockColor,
                                ),
                                const Gap(6),
                                _SkeletonBar(
                                  width: 110,
                                  height: 14,
                                  color: blockColor,
                                ),
                              ],
                            ),
                            _SkeletonBar(
                              width: 85,
                              height: 18,
                              color: blockColor,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                _SkeletonBar(
                                  width: 76,
                                  height: 12,
                                  color: blockColor,
                                ),
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: blockColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            childCount: itemCount,
          ),
        );
      },
    );
  }
}

class _SkeletonBar extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const _SkeletonBar({
    required this.width,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}