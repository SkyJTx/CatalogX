import 'package:dio/dio.dart';

import '../models/catalog_filter.dart';
import '../models/product.dart';
import '../models/product_category.dart';
import '../models/product_list_response.dart';

class AppException implements Exception {
  final String messageTh;
  final String messageEn;
  final int? statusCode;
  final bool isCancelled;

  const AppException({
    required this.messageTh,
    required this.messageEn,
    this.statusCode,
    this.isCancelled = false,
  });

  String localizedMessage(AppLanguage language) {
    return language == AppLanguage.th ? messageTh : messageEn;
  }

  @override
  String toString() => messageEn;
}

abstract interface class ProductRepository {
  Future<ProductListResponse> getProducts({
    required int limit,
    required int skip,
    String? searchQuery,
    String? categorySlug,
    CatalogSortOption sortOption = CatalogSortOption.popular,
    CancelToken? cancelToken,
  });

  Future<Product> getProductById(
    int id, {
    CancelToken? cancelToken,
  });

  Future<List<ProductCategory>> getCategories({
    CancelToken? cancelToken,
  });
}