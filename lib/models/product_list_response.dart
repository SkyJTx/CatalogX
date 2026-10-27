import 'product.dart';

class ProductListResponse {
  final List<Product> products;
  final int total;
  final int skip;
  final int limit;

  const ProductListResponse({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  bool get hasMore => skip + products.length < total;

  factory ProductListResponse.fromJson(Map<String, Object?> json) {
    final rawProducts = json['products'];
    final products = rawProducts is List
        ? rawProducts
            .whereType<Map<Object?, Object?>>()
            .map(
              (item) => Product.fromJson(
                item.map((k, v) => MapEntry(k.toString(), v)),
              ),
            )
            .toList(growable: false)
        : const <Product>[];

    return ProductListResponse(
      products: products,
      total: (json['total'] as num?)?.toInt() ?? products.length,
      skip: (json['skip'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? products.length,
    );
  }
}