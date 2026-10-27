import 'package:hive_ce/hive.dart';
import 'package:material_ui/material_ui.dart';

import '../constants.dart';
import '../models/catalog_filter.dart';
import '../models/product.dart';
import 'local_storage_repository.dart';

class HiveLocalStorageRepository implements LocalStorageRepository {
  final Box<dynamic> _settingsBox;
  final Box<dynamic> _wishlistBox;

  const HiveLocalStorageRepository({
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
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await _settingsBox.put(StorageConstants.themeModeKey, value);
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
    for (final key in _wishlistBox.keys) {
      final rawValue = _wishlistBox.get(key);
      if (rawValue is Map<Object?, Object?>) {
        try {
          final normalized = _normalizeMap(rawValue);
          final product = Product.fromJson(normalized);
          if (product.id > 0) {
            result[product.id] = product;
          }
        } catch (_) {
          continue;
        }
      }
    }
    return result;
  }

  @override
  Future<void> saveWishlistProduct(Product product) async {
    await _wishlistBox.put(product.id.toString(), product.toJson());
  }

  @override
  Future<void> removeWishlistProduct(int productId) async {
    await _wishlistBox.delete(productId.toString());
  }

  @override
  Future<void> clearWishlist() async {
    await _wishlistBox.clear();
  }

  Map<String, Object?> _normalizeMap(Map<Object?, Object?> source) {
    return source.map((key, value) {
      return MapEntry(key.toString(), _normalizeValue(value));
    });
  }

  Object? _normalizeValue(Object? value) {
    if (value is Map<Object?, Object?>) {
      return _normalizeMap(value);
    }
    if (value is List<Object?>) {
      return value.map(_normalizeValue).toList(growable: false);
    }
    return value;
  }
}