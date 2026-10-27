import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '/interfaces/product_repository.dart';
import '/models/product.dart';
import '/models/product_category.dart';

final categoriesProvider = FutureProvider<List<ProductCategory>>((ref) async {
  return GetIt.I<ProductRepository>().getCategories();
});

class ProductDetailNotifier extends AsyncNotifier<Product> {
  final int _productId;
  final ProductRepository _productRepository;

  ProductDetailNotifier({
    required this._productId,
    required this._productRepository,
  });

  @override
  Future<Product> build() async {
    return _productRepository.getProductById(_productId);
  }

  Future<void> refreshProduct() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _productRepository.getProductById(_productId),
    );
  }
}

final productDetailProvider = AsyncNotifierProvider.family
    .autoDispose<ProductDetailNotifier, Product, int>(
  (productId) => ProductDetailNotifier(
    productId: productId,
    productRepository: GetIt.I<ProductRepository>(),
  ),
);
