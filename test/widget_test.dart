import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';
import 'package:product_catalog_app/di.dart';
import 'package:product_catalog_app/main.dart';
import 'package:product_catalog_app/models/app_language.dart';
import 'package:product_catalog_app/models/catalog_sort_option.dart';
import 'package:product_catalog_app/models/product.dart';
import 'package:product_catalog_app/models/product_category.dart';
import 'package:product_catalog_app/models/product_dimensions.dart';
import 'package:product_catalog_app/models/product_list_response.dart';
import 'package:product_catalog_app/models/product_meta.dart';
import 'package:product_catalog_app/models/product_review.dart';
import 'package:product_catalog_app/interfaces/local_storage_repository.dart';
import 'package:product_catalog_app/interfaces/product_repository.dart';
import 'package:product_catalog_app/models/app_exception.dart';
import 'package:product_catalog_app/router.dart';
import 'package:product_catalog_app/state/catalog_notifier.dart';
import 'package:product_catalog_app/state/locale_notifier.dart';
import 'package:product_catalog_app/state/theme_notifier.dart';
import 'package:product_catalog_app/state/wishlist_notifier.dart';
import 'package:product_catalog_app/ui/components/product_card.dart';
import 'package:product_catalog_app/ui/presentations/product_detail/product_info_section.dart';
import 'package:responsive_framework/responsive_framework.dart';

class FakeLocalStorageRepository implements LocalStorageRepository {
  ThemeMode _themeMode = ThemeMode.light;
  AppLanguage _language = AppLanguage.th;
  final Map<int, Product> _wishlist = <int, Product>{};

  @override
  ThemeMode getThemeMode() => _themeMode;

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
  }

  @override
  AppLanguage getLanguage() => _language;

  @override
  Future<void> setLanguage(AppLanguage language) async {
    _language = language;
  }

  @override
  Map<int, Product> getWishlistProducts() => Map<int, Product>.from(_wishlist);

  @override
  Future<void> saveWishlistProduct(Product product) async {
    _wishlist[product.id] = product;
  }

  @override
  Future<void> removeWishlistProduct(int productId) async {
    _wishlist.remove(productId);
  }

  @override
  Future<void> clearWishlist() async {
    _wishlist.clear();
  }
}

class FakeProductRepository implements ProductRepository {
  final List<Product> allProducts;
  bool shouldFail = false;

  FakeProductRepository({required this.allProducts});

  @override
  Future<ProductListResponse> getProducts({
    required int limit,
    required int skip,
    String? searchQuery,
    String? categorySlug,
    CatalogSortOption sortOption = CatalogSortOption.popular,
    CancelToken? cancelToken,
  }) async {
    if (shouldFail) {
      throw const AppException(
        messageTh: 'จำลองข้อผิดพลาดเครือข่าย',
        messageEn: 'Simulated network error',
        statusCode: 503,
      );
    }

    var filtered = List<Product>.from(allProducts);
    if (categorySlug != null && categorySlug.isNotEmpty) {
      filtered = filtered
          .where((item) => item.category == categorySlug)
          .toList();
    }
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final needle = searchQuery.trim().toLowerCase();
      filtered = filtered
          .where((item) => item.title.toLowerCase().contains(needle))
          .toList();
    }

    final paged = filtered.skip(skip).take(limit).toList(growable: false);
    return ProductListResponse(
      products: paged,
      total: filtered.length,
      skip: skip,
      limit: limit,
    );
  }

  @override
  Future<Product> getProductById(int id, {CancelToken? cancelToken}) async {
    if (shouldFail) {
      throw const AppException(
        messageTh: 'ไม่พบสินค้า',
        messageEn: 'Product not found',
        statusCode: 404,
      );
    }
    return allProducts.firstWhere(
      (item) => item.id == id,
      orElse: () => allProducts.first,
    );
  }

  @override
  Future<List<ProductCategory>> getCategories({
    CancelToken? cancelToken,
  }) async {
    return const <ProductCategory>[
      ProductCategory(
        slug: 'smartphones',
        name: 'Smartphones',
        url: 'https://dummyjson.com/products/category/smartphones',
      ),
      ProductCategory(
        slug: 'laptops',
        name: 'Laptops',
        url: 'https://dummyjson.com/products/category/laptops',
      ),
    ];
  }
}

List<Product> _buildSampleProducts({int count = 25}) {
  return List<Product>.generate(count, (index) {
    final id = index + 1;
    final isLaptop = id % 2 == 0;
    return Product(
      id: id,
      title: 'Test Product #$id',
      description: 'Detailed specification for Test Product #$id.',
      category: isLaptop ? 'laptops' : 'smartphones',
      price: 100.0 + (id * 10),
      discountPercentage: 20.0,
      rating: 4.8,
      stock: id == 1 ? 4 : 45,
      tags: const <String>['tech', 'featured'],
      brand: 'CatalogX Lab',
      sku: 'SKU-TEST-$id',
      weight: 185,
      dimensions: const ProductDimensions(width: 14.6, height: 7.1, depth: 0.8),
      warrantyInformation: '1 year official warranty',
      shippingInformation: 'Ships within 24 hours',
      availabilityStatus: 'In Stock',
      reviews: <ProductReview>[
        ProductReview(
          rating: 5,
          comment: 'Excellent build quality!',
          date: DateTime.utc(2026, 5, 10),
          reviewerName: 'Nattakarn K.',
          reviewerEmail: 'nattakarn@example.com',
        ),
      ],
      returnPolicy: '30 days free return',
      minimumOrderQuantity: 1,
      meta: const ProductMeta(barcode: '1234567890123', qrCode: ''),
      images: const <String>[],
      thumbnail: '',
    );
  });
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  late FakeProductRepository fakeProductRepo;
  late FakeLocalStorageRepository fakeStorageRepo;

  setUp(() async {
    await GetIt.I.reset();
    fakeProductRepo = FakeProductRepository(
      allProducts: _buildSampleProducts(count: 25),
    );
    fakeStorageRepo = FakeLocalStorageRepository();
    await inject(
      productRepositoryOverride: fakeProductRepo,
      localStorageRepositoryOverride: fakeStorageRepo,
    );
    router.go('/');
  });

  group('Domain Models & Price Math', () {
    test('Product.fromJson and toJson preserve fields and compute discounts', () {
      final sample = _buildSampleProducts(count: 1).first;
      final json = sample.toJson();
      final restored = Product.fromJson(json);

      expect(restored.id, sample.id);
      expect(restored.title, sample.title);
      expect(restored.hasDiscount, isTrue);
      expect(restored.originalPrice, closeTo(137.5, 0.01));
      expect(restored.savingsAmount, closeTo(27.5, 0.01));
      expect(restored.isLowStock, isTrue);
      expect(restored.dimensions.formatted, '14.6 × 7.1 × 0.8 cm');
    });
  });

  group('Riverpod 3.4 Notifiers (Pagination, Error, Empty, Wishlist, i18n)', () {
    test('CatalogNotifier loads page 1 (20 items) and loadMore appends page 2 (5 items)', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(catalogProvider);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final page1 = container.read(catalogProvider);
      expect(page1.isInitialLoading, isFalse);
      expect(page1.products.length, 20);
      expect(page1.total, 25);
      expect(page1.hasMore, isTrue);

      await container.read(catalogProvider.notifier).loadMore();
      final page2 = container.read(catalogProvider);
      expect(page2.products.length, 25);
      expect(page2.hasMore, isFalse);
    });

    test('CatalogNotifier handles Error state and recovers on refresh', () async {
      fakeProductRepo.shouldFail = true;
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(catalogProvider);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final errorState = container.read(catalogProvider);
      expect(errorState.error, isNotNull);
      expect(errorState.products, isEmpty);

      fakeProductRepo.shouldFail = false;
      await container.read(catalogProvider.notifier).refresh();
      final recovered = container.read(catalogProvider);
      expect(recovered.error, isNull);
      expect(recovered.products.length, 20);
    });

    test('WishlistNotifier, ThemeModeNotifier, and LocaleNotifier persist state', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final product = _buildSampleProducts(count: 1).first;
      await container.read(wishlistProvider.notifier).toggle(product);
      expect(container.read(wishlistProvider).containsKey(product.id), isTrue);
      expect(fakeStorageRepo.getWishlistProducts().containsKey(product.id), isTrue);

      await container
          .read(themeModeProvider.notifier)
          .setThemeMode(ThemeMode.dark);
      expect(container.read(themeModeProvider), ThemeMode.dark);
      expect(fakeStorageRepo.getThemeMode(), ThemeMode.dark);

      await container.read(localeProvider.notifier).toggleLanguage();
      expect(container.read(localeProvider), AppLanguage.en);
      expect(fakeStorageRepo.getLanguage(), AppLanguage.en);
    });
  });

  group('Responsive Mobile & Tablet UI Verification', () {
    testWidgets('Mobile (< 600px) renders 2-column grid, toggles TH/EN, and opens Detail with sticky bottom bar', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pumpAndSettle();

      expect(find.text('CatalogX'), findsOneWidget);
      expect(find.text('แสดง 20 จาก 25 รายการ'), findsOneWidget);
      expect(find.byType(ProductCard), findsWidgets);

      final grid = tester.widget<SliverGrid>(find.byType(SliverGrid));
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 2);

      await tester.tap(find.text('TH'));
      await tester.pumpAndSettle();
      expect(find.text('Showing 20 of 25 items'), findsOneWidget);

      await tester.tap(find.text('Test Product #1'));
      await tester.pumpAndSettle();

      expect(find.text('Product Details'), findsOneWidget);
      expect(find.byType(DetailBottomActionBar), findsOneWidget);
    });

    testWidgets('Tablet (>= 600px) renders 3-column catalog grid and 2-column split Product Detail layout', (tester) async {
      tester.view.physicalSize = const Size(820, 1180);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      await tester.pumpAndSettle();

      final grid = tester.widget<SliverGrid>(find.byType(SliverGrid));
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 3);

      await tester.tap(find.text('Test Product #1'));
      await tester.pumpAndSettle();

      expect(find.byType(DetailBottomActionBar), findsNothing);
      final responsiveSplits = tester
          .widgetList<ResponsiveRowColumn>(find.byType(ResponsiveRowColumn))
          .toList();
      expect(
        responsiveSplits.any(
          (widget) => widget.layout == ResponsiveRowColumnType.ROW,
        ),
        isTrue,
      );
    });
  });
}