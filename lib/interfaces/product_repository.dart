import 'package:dio/dio.dart';

import '/models/catalog_sort_option.dart';
import '/models/product.dart';
import '/models/product_category.dart';
import '/models/product_list_response.dart';

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
