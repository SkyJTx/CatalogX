enum CatalogSortOption {
  popular,
  priceLowToHigh,
  priceHighToLow,
  highestRated,
  biggestDiscount;

  String? get sortByField => switch (this) {
    CatalogSortOption.popular => null,
    CatalogSortOption.priceLowToHigh ||
    CatalogSortOption.priceHighToLow => 'price',
    CatalogSortOption.highestRated => 'rating',
    CatalogSortOption.biggestDiscount => 'discountPercentage',
  };

  String? get sortOrder => switch (this) {
    CatalogSortOption.popular => null,
    CatalogSortOption.priceLowToHigh => 'asc',
    CatalogSortOption.priceHighToLow ||
    CatalogSortOption.highestRated ||
    CatalogSortOption.biggestDiscount => 'desc',
  };
}
