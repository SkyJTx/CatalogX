import '../constants.dart';
import '../models/catalog_filter.dart';
import '../models/product.dart';
import '../repo/product_repository.dart';

class CatalogState {
  final List<Product> products;
  final int total;
  final int skip;
  final bool isInitialLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final AppException? error;
  final AppException? loadMoreError;
  final String searchQuery;
  final String? selectedCategorySlug;
  final bool isWishlistOnly;
  final CatalogSortOption sortOption;

  const CatalogState({
    this.products = const <Product>[],
    this.total = 0,
    this.skip = 0,
    this.isInitialLoading = true,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.error,
    this.loadMoreError,
    this.searchQuery = '',
    this.selectedCategorySlug,
    this.isWishlistOnly = false,
    this.sortOption = CatalogSortOption.popular,
  });

  bool get hasMore => !isWishlistOnly && products.length < total;

  bool get isEmpty => !isInitialLoading && error == null && products.isEmpty;

  int get currentPage {
    if (products.isEmpty) return 1;
    return ((products.length - 1) ~/ ApiConstants.pageSize) + 1;
  }

  int get totalPages {
    if (total <= 0) return 1;
    return ((total - 1) ~/ ApiConstants.pageSize) + 1;
  }

  double get loadProgress {
    if (total <= 0) return 0.0;
    return (products.length / total).clamp(0.0, 1.0);
  }

  CatalogState copyWith({
    List<Product>? products,
    int? total,
    int? skip,
    bool? isInitialLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    AppException? error,
    bool clearError = false,
    AppException? loadMoreError,
    bool clearLoadMoreError = false,
    String? searchQuery,
    String? selectedCategorySlug,
    bool clearCategory = false,
    bool? isWishlistOnly,
    CatalogSortOption? sortOption,
  }) {
    return CatalogState(
      products: products ?? this.products,
      total: total ?? this.total,
      skip: skip ?? this.skip,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : (error ?? this.error),
      loadMoreError:
          clearLoadMoreError ? null : (loadMoreError ?? this.loadMoreError),
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategorySlug: clearCategory
          ? null
          : (selectedCategorySlug ?? this.selectedCategorySlug),
      isWishlistOnly: isWishlistOnly ?? this.isWishlistOnly,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}