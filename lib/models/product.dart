import 'product_dimensions.dart';
import 'product_meta.dart';
import 'product_review.dart';

class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String brand;
  final String sku;
  final double weight;
  final ProductDimensions dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<ProductReview> reviews;
  final String returnPolicy;
  final int minimumOrderQuantity;
  final ProductMeta meta;
  final List<String> images;
  final String thumbnail;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.reviews,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.meta,
    required this.images,
    required this.thumbnail,
  });

  bool get hasDiscount => discountPercentage >= 1.0 && discountPercentage < 95.0;

  double get originalPrice {
    if (!hasDiscount) return price;
    return price / (1.0 - (discountPercentage / 100.0));
  }

  double get savingsAmount {
    final diff = originalPrice - price;
    return diff > 0 ? diff : 0.0;
  }

  bool get isLowStock => stock > 0 && stock <= 10;

  bool get isOutOfStock => stock <= 0;

  List<String> get galleryImages {
    if (images.isNotEmpty) return images;
    if (thumbnail.isNotEmpty) return <String>[thumbnail];
    return const <String>[];
  }

  factory Product.fromJson(Map<String, Object?> json) {
    final rawTags = json['tags'];
    final tags = rawTags is List
        ? rawTags.whereType<String>().toList(growable: false)
        : const <String>[];

    final rawImages = json['images'];
    final images = rawImages is List
        ? rawImages.whereType<String>().toList(growable: false)
        : const <String>[];

    final rawReviews = json['reviews'];
    final reviews = rawReviews is List
        ? rawReviews
            .whereType<Map<Object?, Object?>>()
            .map(
              (item) => ProductReview.fromJson(
                item.map((k, v) => MapEntry(k.toString(), v)),
              ),
            )
            .toList(growable: false)
        : const <ProductReview>[];

    final rawDimensions = json['dimensions'];
    final dimensions = rawDimensions is Map<Object?, Object?>
        ? ProductDimensions.fromJson(
            rawDimensions.map((k, v) => MapEntry(k.toString(), v)),
          )
        : const ProductDimensions(width: 0, height: 0, depth: 0);

    final rawMeta = json['meta'];
    final meta = rawMeta is Map<Object?, Object?>
        ? ProductMeta.fromJson(
            rawMeta.map((k, v) => MapEntry(k.toString(), v)),
          )
        : const ProductMeta(barcode: '', qrCode: '');

    final category = (json['category'] as String?) ?? 'general';
    final brand = (json['brand'] as String?)?.trim();

    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      category: category,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      tags: tags,
      brand: (brand != null && brand.isNotEmpty) ? brand : _capitalize(category),
      sku: (json['sku'] as String?) ?? 'SKU-${json['id'] ?? 0}',
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      dimensions: dimensions,
      warrantyInformation:
          (json['warrantyInformation'] as String?) ?? '1 year warranty',
      shippingInformation:
          (json['shippingInformation'] as String?) ?? 'Standard shipping',
      availabilityStatus:
          (json['availabilityStatus'] as String?) ?? 'In Stock',
      reviews: reviews,
      returnPolicy: (json['returnPolicy'] as String?) ?? '30 days return policy',
      minimumOrderQuantity:
          (json['minimumOrderQuantity'] as num?)?.toInt() ?? 1,
      meta: meta,
      images: images,
      thumbnail: (json['thumbnail'] as String?) ??
          (images.isNotEmpty ? images.first : ''),
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'tags': tags,
      'brand': brand,
      'sku': sku,
      'weight': weight,
      'dimensions': dimensions.toJson(),
      'warrantyInformation': warrantyInformation,
      'shippingInformation': shippingInformation,
      'availabilityStatus': availabilityStatus,
      'reviews': reviews.map((r) => r.toJson()).toList(growable: false),
      'returnPolicy': returnPolicy,
      'minimumOrderQuantity': minimumOrderQuantity,
      'meta': meta.toJson(),
      'images': images,
      'thumbnail': thumbnail,
    };
  }

  static String _capitalize(String value) {
    if (value.isEmpty) return 'CatalogX';
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }
}