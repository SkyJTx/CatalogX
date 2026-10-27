class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'https://dummyjson.com';
  static const String productsPath = '/products';
  static const String productsSearchPath = '/products/search';
  static const String categoriesPath = '/products/categories';
  static const int pageSize = 20;
  static const Duration connectTimeout = Duration(seconds: 12);
  static const Duration receiveTimeout = Duration(seconds: 12);
}

class StorageConstants {
  const StorageConstants._();

  static const String settingsBox = 'catalogx_settings_box';
  static const String wishlistBox = 'catalogx_wishlist_box';
  static const String themeModeKey = 'theme_mode';
  static const String languageCodeKey = 'language_code';
}

class LayoutConstants {
  const LayoutConstants._();

  static const double mobileMaxWidth = 599;
  static const double tabletStartWidth = 600;
  static const double tabletMaxWidth = 1024;
  static const double desktopStartWidth = 1025;
  static const double desktopMaxWidth = 1920;
  static const double contentMaxWidth = 1280;
  static const double detailMaxWidth = 1200;
}