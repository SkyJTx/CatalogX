import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../models/product.dart';
import '../models/product_category.dart';
import '../repo/product_repository.dart';

final categoriesProvider = FutureProvider<List<ProductCategory>>((ref) async {
  return GetIt.I<ProductRepository>().getCategories();
});

class ProductDetailNotifier extends AsyncNotifier<Product> {
  final int productId;

  ProductDetailNotifier(this.productId);

  @override
  Future<Product> build() async {
    return GetIt.I<ProductRepository>().getProductById(productId);
  }

  Future<void> refreshProduct() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => GetIt.I<ProductRepository>().getProductById(productId),
    );
  }
}

final productDetailProvider = AsyncNotifierProvider.family
    .autoDispose<ProductDetailNotifier, Product, int>(
  ProductDetailNotifier.new,
);