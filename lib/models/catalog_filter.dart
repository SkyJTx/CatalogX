enum CatalogSortOption {
  popular,
  priceLowToHigh,
  priceHighToLow,
  highestRated,
  biggestDiscount;

  String? get sortByField => switch (this) {
        CatalogSortOption.popular => null,
        CatalogSortOption.priceLowToHigh => 'price',
        CatalogSortOption.priceHighToLow => 'price',
        CatalogSortOption.highestRated => 'rating',
        CatalogSortOption.biggestDiscount => 'discountPercentage',
      };

  String? get sortOrder => switch (this) {
        CatalogSortOption.popular => null,
        CatalogSortOption.priceLowToHigh => 'asc',
        CatalogSortOption.priceHighToLow => 'desc',
        CatalogSortOption.highestRated => 'desc',
        CatalogSortOption.biggestDiscount => 'desc',
      };
}

enum AppLanguage {
  th('th'),
  en('en');

  final String code;
  const AppLanguage(this.code);

  static AppLanguage fromCode(String? raw) {
    if (raw == 'en') return AppLanguage.en;
    return AppLanguage.th;
  }
}