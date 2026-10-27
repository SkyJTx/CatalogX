import 'package:hive_ce/hive.dart';

import '/models/product_review.dart';

class ProductReviewAdapter extends TypeAdapter<ProductReview> {
  const ProductReviewAdapter();

  @override
  int get typeId => 2;

  @override
  ProductReview read(BinaryReader reader) {
    final rating = reader.readInt();
    final comment = reader.readString();
    final dateMillis = reader.readInt();
    final reviewerName = reader.readString();
    final reviewerEmail = reader.readString();
    return ProductReview(
      rating: rating,
      comment: comment,
      date: DateTime.fromMillisecondsSinceEpoch(dateMillis, isUtc: true),
      reviewerName: reviewerName,
      reviewerEmail: reviewerEmail,
    );
  }

  @override
  void write(BinaryWriter writer, ProductReview obj) {
    writer
      ..writeInt(obj.rating)
      ..writeString(obj.comment)
      ..writeInt(obj.date.toUtc().millisecondsSinceEpoch)
      ..writeString(obj.reviewerName)
      ..writeString(obj.reviewerEmail);
  }
}
