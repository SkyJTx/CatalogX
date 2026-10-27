import 'package:hive_ce/hive.dart';

import '/models/product_meta.dart';

class ProductMetaAdapter extends TypeAdapter<ProductMeta> {
  const ProductMetaAdapter();

  @override
  int get typeId => 3;

  @override
  ProductMeta read(BinaryReader reader) {
    final hasCreatedAt = reader.readBool();
    final createdAt = hasCreatedAt
        ? DateTime.fromMillisecondsSinceEpoch(reader.readInt(), isUtc: true)
        : null;
    final hasUpdatedAt = reader.readBool();
    final updatedAt = hasUpdatedAt
        ? DateTime.fromMillisecondsSinceEpoch(reader.readInt(), isUtc: true)
        : null;
    final barcode = reader.readString();
    final qrCode = reader.readString();
    return ProductMeta(
      createdAt: createdAt,
      updatedAt: updatedAt,
      barcode: barcode,
      qrCode: qrCode,
    );
  }

  @override
  void write(BinaryWriter writer, ProductMeta obj) {
    final createdAt = obj.createdAt;
    if (createdAt != null) {
      writer
        ..writeBool(true)
        ..writeInt(createdAt.toUtc().millisecondsSinceEpoch);
    } else {
      writer.writeBool(false);
    }

    final updatedAt = obj.updatedAt;
    if (updatedAt != null) {
      writer
        ..writeBool(true)
        ..writeInt(updatedAt.toUtc().millisecondsSinceEpoch);
    } else {
      writer.writeBool(false);
    }

    writer
      ..writeString(obj.barcode)
      ..writeString(obj.qrCode);
  }
}
