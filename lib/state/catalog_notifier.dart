import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../constants.dart';
import '../models/catalog_filter.dart';
import '../models/product.dart';
import '../repo/product_repository.dart';
import 'catalog_state.dart';
import 'wishlist_notifier.dart';

class CatalogNotifier extends Notifier<CatalogState> {
  Timer? _searchDebounce;
  CancelToken? _activeCancelToken;
  bool _isDisposed = false;

  @override
  CatalogState build() {
    _isDisposed = false;

    ref.listen<Map<int, Product>>(wishlistProvider, (previous, next) {
      if (!_isDisposed && state.isWishlistOnly) {
        _applyWishlistItems(next);
      }
    });

    ref.onDispose(() {
      _isDisposed = true;
      _searchDebounce?.cancel();
      _activeCancelToken?.cancel();
    });

    Future<void>.microtask(_fetchFirstPage);
    return const CatalogState(isInitialLoading: true);
  }

  void updateSearchQuery(String query) {
    _searchDebounce?.cancel();
    state = state.copyWith(searchQuery: query);

    if (state.isWishlistOnly) {
      _applyWishlistItems(ref.read(wishlistProvider));
      return;
    }

    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (!_isDisposed) {
        _fetchFirstPage();
      }
    });
  }

  Future<void> submitSearchImmediately(String query) async {
    _searchDebounce?.cancel();
    state = state.copyWith(searchQuery: query);
    if (state.isWishlistOnly) {
      _applyWishlistItems(ref.read(wishlistProvider));
      return;
    }
    await _fetchFirstPage();
  }

  Future<void> selectCategory(String? categorySlug) async {
    _searchDebounce?.cancel();
    final isSame = !state.isWishlistOnly &&
        state.selectedCategorySlug == categorySlug;
    if (isSame && !state.isInitialLoading && state.error == null) return;

    state = state.copyWith(
      selectedCategorySlug: categorySlug,
      clearCategory: categorySlug == null,
      isWishlistOnly: false,
    );
    await _fetchFirstPage();
  }

  void selectWishlistOnly() {
    _searchDebounce?.cancel();
    _activeCancelToken?.cancel();
    state = state.copyWith(
      isWishlistOnly: true,
      clearCategory: true,
      isInitialLoading: false,
      isRefreshing: false,
      isLoadingMore: false,
      clearError: true,
      clearLoadMoreError: true,
    );
    _applyWishlistItems(ref.read(wishlistProvider));
  }

  Future<void> updateSort(CatalogSortOption option) async {
    if (state.sortOption == option) return;
    state = state.copyWith(sortOption: option);
    if (state.isWishlistOnly) {
      _applyWishlistItems(ref.read(wishlistProvider));
      return;
    }
    await _fetchFirstPage();
  }

  Future<void> refresh() async {
    if (state.isWishlistOnly) {
      _applyWishlistItems(ref.read(wishlistProvider));
      return;
    }
    await _fetchFirstPage(isPullToRefresh: true);
  }

  Future<void> resetFilters() async {
    _searchDebounce?.cancel();
    state = const CatalogState(isInitialLoading: true);
    await _fetchFirstPage();
  }

  Future<void> loadMore() async {
    if (state.isWishlistOnly ||
        state.isInitialLoading ||
        state.isRefreshing ||
        state.isLoadingMore ||
        !state.hasMore) {
      return;
    }

    final nextSkip = state.products.length;
    state = state.copyWith(
      isLoadingMore: true,
      clearLoadMoreError: true,
    );

    final cancelToken = CancelToken();
    _activeCancelToken = cancelToken;

    try {
      final repo = GetIt.I<ProductRepository>();
      final response = await repo.getProducts(
        limit: ApiConstants.pageSize,
        skip: nextSkip,
        searchQuery: state.searchQuery,
        categorySlug: state.selectedCategorySlug,
        sortOption: state.sortOption,
        cancelToken: cancelToken,
      );

      if (_isDisposed) return;

      final existingIds = state.products.map((item) => item.id).toSet();
      final merged = <Product>[
        ...state.products,
        ...response.products.where((item) => !existingIds.contains(item.id)),
      ];

      state = state.copyWith(
        products: merged,
        total: response.total,
        skip: nextSkip,
        isLoadingMore: false,
        clearLoadMoreError: true,
      );
    } on AppException catch (error) {
      if (_isDisposed || error.isCancelled) return;
      state = state.copyWith(
        isLoadingMore: false,
        loadMoreError: error,
      );
    } catch (_) {
      if (_isDisposed) return;
      state = state.copyWith(
        isLoadingMore: false,
        loadMoreError: const AppException(
          messageTh: 'ไม่สามารถโหลดสินค้าหน้าถัดไปได้ กรุณาลองใหม่',
          messageEn: 'Could not load more products. Please try again.',
        ),
      );
    }
  }

  Future<void> _fetchFirstPage({bool isPullToRefresh = false}) async {
    if (_isDisposed) return;

    _activeCancelToken?.cancel();
    final cancelToken = CancelToken();
    _activeCancelToken = cancelToken;

    state = state.copyWith(
      isInitialLoading: !isPullToRefresh,
      isRefreshing: isPullToRefresh,
      isLoadingMore: false,
      clearError: true,
      clearLoadMoreError: true,
      skip: 0,
    );

    try {
      final repo = GetIt.I<ProductRepository>();
      final response = await repo.getProducts(
        limit: ApiConstants.pageSize,
        skip: 0,
        searchQuery: state.searchQuery,
        categorySlug: state.selectedCategorySlug,
        sortOption: state.sortOption,
        cancelToken: cancelToken,
      );

      if (_isDisposed) return;

      state = state.copyWith(
        products: response.products,
        total: response.total,
        skip: 0,
        isInitialLoading: false,
        isRefreshing: false,
        clearError: true,
      );
    } on AppException catch (error) {
      if (_isDisposed || error.isCancelled) return;
      state = state.copyWith(
        products: const <Product>[],
        total: 0,
        isInitialLoading: false,
        isRefreshing: false,
        error: error,
      );
    } catch (_) {
      if (_isDisposed) return;
      state = state.copyWith(
        products: const <Product>[],
        total: 0,
        isInitialLoading: false,
        isRefreshing: false,
        error: const AppException(
          messageTh: 'เกิดข้อผิดพลาดที่ไม่คาดคิด กรุณาลองใหม่อีกครั้ง',
          messageEn: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  void _applyWishlistItems(Map<int, Product> wishlistMap) {
    final query = state.searchQuery.trim().toLowerCase();
    var items = wishlistMap.values.toList();

    if (query.isNotEmpty) {
      items = items.where((product) {
        return product.title.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query) ||
            product.brand.toLowerCase().contains(query) ||
            product.category.toLowerCase().contains(query);
      }).toList();
    }

    switch (state.sortOption) {
      case CatalogSortOption.popular:
        break;
      case CatalogSortOption.priceLowToHigh:
        items.sort((a, b) => a.price.compareTo(b.price));
      case CatalogSortOption.priceHighToLow:
        items.sort((a, b) => b.price.compareTo(a.price));
      case CatalogSortOption.highestRated:
        items.sort((a, b) => b.rating.compareTo(a.rating));
      case CatalogSortOption.biggestDiscount:
        items.sort(
          (a, b) => b.discountPercentage.compareTo(a.discountPercentage),
        );
    }

    state = state.copyWith(
      products: items,
      total: items.length,
      skip: 0,
      isInitialLoading: false,
      isRefreshing: false,
      isLoadingMore: false,
      clearError: true,
      clearLoadMoreError: true,
    );
  }
}

final catalogProvider = NotifierProvider<CatalogNotifier, CatalogState>(
  CatalogNotifier.new,
);