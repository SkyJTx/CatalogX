class ProductDimensions {
  final double width;
  final double height;
  final double depth;

  const ProductDimensions({
    required this.width,
    required this.height,
    required this.depth,
  });

  factory ProductDimensions.fromJson(Map<String, Object?> json) {
    return ProductDimensions(
      width: (json['width'] as num?)?.toDouble() ?? 0.0,
      height: (json['height'] as num?)?.toDouble() ?? 0.0,
      depth: (json['depth'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'width': width,
      'height': height,
      'depth': depth,
    };
  }

  String get formatted =>
      '${width.toStringAsFixed(1)} × ${height.toStringAsFixed(1)} × ${depth.toStringAsFixed(1)} cm';
}