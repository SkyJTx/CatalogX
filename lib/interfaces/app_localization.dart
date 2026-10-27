import '/models/app_language.dart';
import '/models/catalog_sort_option.dart';

abstract interface class AppLocalization {
  AppLanguage get language;
  bool get isThai;
  String get appTitle;
  String get appSubtitle;
  String get searchHint;
  String get allCategoriesLabel;
  String wishlistFilterLabel(int count);
  String showingResultsCount(int loaded, int total);
  String pageProgressText({
    required int currentPage,
    required int totalPages,
    required int loaded,
    required int total,
  });
  String get loadMoreButton;
  String get loadingMoreButton;
  String get allProductsLoaded;
  String sortLabel(CatalogSortOption option);
  String inStockBadge(int stock);
  String lowStockBadge(int stock);
  String get outOfStockBadge;
  String discountPill(int percent);
  String saveBadge(String amount);
  String reviewsCountLabel(int count);
  String get productDetailsTitle;
  String get quantityLabel;
  String get tabOverview;
  String get tabShippingAndReturns;
  String tabReviews(int count);
  String get specDimensionsTitle;
  String specWeightValue(double weight);
  String get specSkuTitle;
  String specMinOrderValue(int minOrder);
  String get specWarrantyTitle;
  String get specShippingTitle;
  String get specReturnPolicyTitle;
  String get specBarcodeTitle;
  String get trustAuthenticTitle;
  String get trustAuthenticSubtitle;
  String get trustInstallmentTitle;
  String get trustInstallmentSubtitle;
  String get trustReturnTitle;
  String get trustReturnSubtitle;
  String get addToCartButton;
  String get buyNowButton;
  String addedToCartMessage(String title, int qty);
  String addedToWishlistMessage(String title);
  String removedFromWishlistMessage(String title);
  String get errorStateTitle;
  String get retryButtonLabel;
  String get emptyStateTitle;
  String get emptyStateSubtitle;
  String get emptyWishlistSubtitle;
  String get resetFiltersButton;
  String get settingsSheetTitle;
  String get themeSectionTitle;
  String get themeLightLabel;
  String get themeDarkLabel;
  String get themeSystemLabel;
  String get languageSectionTitle;
  String get languageThaiLabel;
  String get languageEnglishLabel;
  String wishlistStorageSummary(int count);
  String get clearWishlistButton;
  String get noReviewsMessage;
  String formatPrice(double value);
  String formatDate(DateTime date);
}
