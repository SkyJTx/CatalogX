import 'package:hive_ce/hive.dart';

import '/models/product_dimensions.dart';

class ProductDimensionsAdapter extends TypeAdapter<ProductDimensions> {
  const ProductDimensionsAdapter();

  @override
  int get typeId => 1;

  @override
  ProductDimensions read(BinaryReader reader) {
    final width = reader.readDouble();
    final height = reader.readDouble();
    final depth = reader.readDouble();
    return ProductDimensions(
      width: width,
      height: height,
      depth: depth,
    );
  }

  @override
  void write(BinaryWriter writer, ProductDimensions obj) {
    writer
      ..writeDouble(obj.width)
      ..writeDouble(obj.height)
      ..writeDouble(obj.depth);
  }
}
