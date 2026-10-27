import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

import '/constants.dart';
import '/interfaces/local_storage_repository.dart';
import '/models/app_language.dart';
import '/models/product.dart';

class HiveLocalStorageRepository implements LocalStorageRepository {
  final Box<Object?> _settingsBox;
  final Box<Product> _wishlistBox;

  HiveLocalStorageRepository({
    required this._settingsBox,
    required this._wishlistBox,
  });

  @override
  ThemeMode getThemeMode() {
    final raw = _settingsBox.get(StorageConstants.themeModeKey) as String?;
    return switch (raw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    final serialized = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _settingsBox.put(StorageConstants.themeModeKey, serialized);
  }

  @override
  AppLanguage getLanguage() {
    final raw = _settingsBox.get(StorageConstants.languageCodeKey) as String?;
    return AppLanguage.fromCode(raw);
  }

  @override
  Future<void> setLanguage(AppLanguage language) async {
    await _settingsBox.put(StorageConstants.languageCodeKey, language.code);
  }

  @override
  Map<int, Product> getWishlistProducts() {
    final result = <int, Product>{};
    for (final product in _wishlistBox.values) {
      if (product.id > 0) {
        result[product.id] = product;
      }
    }
    return result;
  }

  @override
  Future<void> saveWishlistProduct(Product product) async {
    await _wishlistBox.put(product.id.toString(), product);
  }

  @override
  Future<void> removeWishlistProduct(int productId) async {
    await _wishlistBox.delete(productId.toString());
  }

  @override
  Future<void> clearWishlist() async {
    await _wishlistBox.clear();
  }
}
