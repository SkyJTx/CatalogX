import 'package:hive_ce/hive.dart';

import '/models/product.dart';
import '/models/product_dimensions.dart';
import '/models/product_meta.dart';
import '/models/product_review.dart';

class ProductAdapter extends TypeAdapter<Product> {
  const ProductAdapter();

  @override
  int get typeId => 0;

  @override
  Product read(BinaryReader reader) {
    final id = reader.readInt();
    final title = reader.readString();
    final description = reader.readString();
    final category = reader.readString();
    final price = reader.readDouble();
    final discountPercentage = reader.readDouble();
    final rating = reader.readDouble();
    final stock = reader.readInt();
    final tags = reader.readStringList();
    final brand = reader.readString();
    final sku = reader.readString();
    final weight = reader.readDouble();
    final dimensions = reader.read() as ProductDimensions;
    final warrantyInformation = reader.readString();
    final shippingInformation = reader.readString();
    final availabilityStatus = reader.readString();
    final reviews = (reader.readList()).cast<ProductReview>();
    final returnPolicy = reader.readString();
    final minimumOrderQuantity = reader.readInt();
    final meta = reader.read() as ProductMeta;
    final images = reader.readStringList();
    final thumbnail = reader.readString();

    return Product(
      id: id,
      title: title,
      description: description,
      category: category,
      price: price,
      discountPercentage: discountPercentage,
      rating: rating,
      stock: stock,
      tags: tags,
      brand: brand,
      sku: sku,
      weight: weight,
      dimensions: dimensions,
      warrantyInformation: warrantyInformation,
      shippingInformation: shippingInformation,
      availabilityStatus: availabilityStatus,
      reviews: reviews,
      returnPolicy: returnPolicy,
      minimumOrderQuantity: minimumOrderQuantity,
      meta: meta,
      images: images,
      thumbnail: thumbnail,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeInt(obj.id)
      ..writeString(obj.title)
      ..writeString(obj.description)
      ..writeString(obj.category)
      ..writeDouble(obj.price)
      ..writeDouble(obj.discountPercentage)
      ..writeDouble(obj.rating)
      ..writeInt(obj.stock)
      ..writeStringList(obj.tags)
      ..writeString(obj.brand)
      ..writeString(obj.sku)
      ..writeDouble(obj.weight)
      ..write<ProductDimensions>(obj.dimensions)
      ..writeString(obj.warrantyInformation)
      ..writeString(obj.shippingInformation)
      ..writeString(obj.availabilityStatus)
      ..writeList(obj.reviews)
      ..writeString(obj.returnPolicy)
      ..writeInt(obj.minimumOrderQuantity)
      ..write<ProductMeta>(obj.meta)
      ..writeStringList(obj.images)
      ..writeString(obj.thumbnail);
  }
}
