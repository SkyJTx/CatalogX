import 'package:intl/intl.dart';

import '/interfaces/app_localization.dart';
import '/models/app_language.dart';
import '/models/catalog_sort_option.dart';

class EnAppLocalization implements AppLocalization {
  const EnAppLocalization();

  static final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: r'$',
    decimalDigits: 2,
  );
  static final DateFormat _dateFormatter = DateFormat('dd MMM yyyy');

  @override
  AppLanguage get language => AppLanguage.en;

  @override
  bool get isThai => false;

  @override
  String formatPrice(double value) => _currencyFormatter.format(value);

  @override
  String formatDate(DateTime date) => _dateFormatter.format(date);

  @override
  String get appTitle => 'CatalogX';

  @override
  String get appSubtitle => 'Curated Editorial Objects';

  @override
  String get pullToRefreshHint => 'Pull down to refresh';

  @override
  String get searchHint => 'Search objects, brands, or categories...';

  @override
  String get allCategoriesLabel => 'All Objects';

  @override
  String wishlistFilterLabel(int count) => 'Saved ($count)';

  @override
  String showingResultsCount(int loaded, int total) =>
      'Showing $loaded of $total items';

  @override
  String pageProgressText({
    required int currentPage,
    required int totalPages,
    required int loaded,
    required int total,
  }) =>
      'Page $currentPage of $totalPages ? $loaded of $total items';

  @override
  String get loadMoreButton => 'Load More';

  @override
  String get loadingMoreButton => 'Loading more...';

  @override
  String get allProductsLoaded => 'End of catalog';

  @override
  String sortLabel(CatalogSortOption option) => switch (option) {
    CatalogSortOption.popular => 'Featured',
    CatalogSortOption.priceLowToHigh => 'Price: Low to High',
    CatalogSortOption.priceHighToLow => 'Price: High to Low',
    CatalogSortOption.highestRated => 'Highest Rated',
    CatalogSortOption.biggestDiscount => 'Largest Savings',
  };

  @override
  String inStockBadge(int stock) => 'In stock ($stock)';

  @override
  String lowStockBadge(int stock) => 'Only $stock left';

  @override
  String get outOfStockBadge => 'Out of stock';

  @override
  String discountPill(int percent) => '-$percent%';

  @override
  String saveBadge(String amount) => 'Save $amount';

  @override
  String reviewsCountLabel(int count) => '$count reviews';

  @override
  String get productDetailsTitle => 'Product Details';

  @override
  String get quantityLabel => 'Quantity';

  @override
  String get tabOverview => 'Specifications';

  @override
  String get tabShippingAndReturns => 'Shipping & Care';

  @override
  String tabReviews(int count) => 'Reviews ($count)';

  @override
  String get specDimensionsTitle => 'Dimensions & Weight';

  @override
  String specWeightValue(double weight) =>
      'Weight ${weight.toStringAsFixed(0)} g';

  @override
  String get specSkuTitle => 'SKU & Minimum Order';

  @override
  String specMinOrderValue(int minOrder) => 'Min. order $minOrder pcs';

  @override
  String get specWarrantyTitle => 'Warranty';

  @override
  String get specShippingTitle => 'Dispatch';

  @override
  String get specReturnPolicyTitle => 'Returns';

  @override
  String get specBarcodeTitle => 'Barcode';

  @override
  String get trustAuthenticTitle => 'Verified Authentic';

  @override
  String get trustAuthenticSubtitle => 'Direct brand provenance';

  @override
  String get trustInstallmentTitle => 'Careful Dispatch';

  @override
  String get trustInstallmentSubtitle => 'Insured protective transit';

  @override
  String get trustReturnTitle => 'Simple Returns';

  @override
  String get trustReturnSubtitle => 'Transparent return window';

  @override
  String get addToCartButton => 'Add to Bag';

  @override
  String get buyNowButton => 'Purchase Now';

  @override
  String addedToCartMessage(String title, int qty) =>
      'Added "$title" ($qty) to your bag';

  @override
  String addedToWishlistMessage(String title) => 'Saved "$title" to wishlist';

  @override
  String removedFromWishlistMessage(String title) =>
      'Removed "$title" from wishlist';

  @override
  String get errorStateTitle => 'Unable to load catalog';

  @override
  String get retryButtonLabel => 'Try Again';

  @override
  String get emptyStateTitle => 'No matching objects found';

  @override
  String get emptyStateSubtitle =>
      'Try adjusting your search keywords or clearing active filters.';

  @override
  String get emptyWishlistSubtitle =>
      'Your saved collection is empty. Tap the heart icon on any item to keep it here.';

  @override
  String get resetFiltersButton => 'Reset Filters';

  @override
  String get settingsSheetTitle => 'Settings';

  @override
  String get themeSectionTitle => 'Appearance';

  @override
  String get themeLightLabel => 'Light';

  @override
  String get themeDarkLabel => 'Dark';

  @override
  String get themeSystemLabel => 'System';

  @override
  String get languageSectionTitle => 'Language';

  @override
  String get languageThaiLabel => '???';

  @override
  String get languageEnglishLabel => 'English';

  @override
  String wishlistStorageSummary(int count) =>
      '$count saved item(s) stored via Hive TypeAdapter';

  @override
  String get clearWishlistButton => 'Clear Saved Items';

  @override
  String get noReviewsMessage => 'No customer reviews recorded yet.';
}
