import 'package:material_ui/material_ui.dart';

import '/models/app_language.dart';
import '/models/product.dart';

abstract interface class LocalStorageRepository {
  ThemeMode getThemeMode();

  Future<void> setThemeMode(ThemeMode mode);

  AppLanguage getLanguage();

  Future<void> setLanguage(AppLanguage language);

  Map<int, Product> getWishlistProducts();

  Future<void> saveWishlistProduct(Product product);

  Future<void> removeWishlistProduct(int productId);

  Future<void> clearWishlist();
}
