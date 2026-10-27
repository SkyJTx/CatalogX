import 'package:intl/intl.dart';

import '../../models/catalog_filter.dart';

class AppStrings {
  final AppLanguage language;

  const AppStrings(this.language);

  bool get isThai => language == AppLanguage.th;

  static final NumberFormat _currencyFormatter = NumberFormat.currency(
    symbol: r'$',
    decimalDigits: 2,
  );

  String formatPrice(double value) => _currencyFormatter.format(value);

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  String get appTitle => 'CatalogX';

  String get appSubtitle =>
      isThai ? 'คลังสินค้าออนไลน์ครบวงจร' : 'Curated Product Catalog';

  String get pullToRefreshHint => isThai
      ? 'เลื่อนลงเพื่อรีเฟรช • Pull down to refresh'
      : 'Pull down to refresh catalog';

  String get searchHint => isThai
      ? 'ค้นหาสินค้า เช่น iPhone, น้ำหอม, โน้ตบุ๊ก...'
      : 'Search products e.g. iPhone, Perfume, Laptop...';

  String get allCategoriesLabel => isThai ? 'ทั้งหมด (All)' : 'All Items';

  String wishlistFilterLabel(int count) => isThai
      ? 'รายการโปรด ($count)'
      : 'Wishlist ($count)';

  String showingResultsCount(int loaded, int total) => isThai
      ? 'แสดง $loaded จาก $total รายการ'
      : 'Showing $loaded of $total items';

  String pageProgressText({
    required int currentPage,
    required int totalPages,
    required int loaded,
    required int total,
  }) {
    return isThai
        ? 'หน้า $currentPage จาก $totalPages • โหลดแล้ว $loaded จาก $total รายการ'
        : 'Page $currentPage of $totalPages • Loaded $loaded of $total items';
  }

  String get loadMoreButton => isThai
      ? 'โหลดสินค้าเพิ่มเติม (Load More)'
      : 'Load More Products';

  String get loadingMoreButton => isThai
      ? 'กำลังโหลดสินค้าเพิ่มเติม...'
      : 'Loading more products...';

  String get allProductsLoaded => isThai
      ? 'แสดงสินค้าครบทุกรายการแล้ว'
      : 'All products loaded';

  String sortLabel(CatalogSortOption option) {
    return switch (option) {
      CatalogSortOption.popular => isThai ? 'ยอดนิยม' : 'Popular',
      CatalogSortOption.priceLowToHigh =>
        isThai ? 'ราคา: ต่ำ → สูง' : 'Price: Low to High',
      CatalogSortOption.priceHighToLow =>
        isThai ? 'ราคา: สูง → ต่ำ' : 'Price: High to Low',
      CatalogSortOption.highestRated =>
        isThai ? 'คะแนนรีวิวสูงสุด' : 'Highest Rated',
      CatalogSortOption.biggestDiscount =>
        isThai ? 'ส่วนลดสูงสุด' : 'Biggest Discount',
    };
  }

  String inStockBadge(int stock) =>
      isThai ? 'มีสินค้า $stock ชิ้น' : 'In stock ($stock)';

  String lowStockBadge(int stock) =>
      isThai ? 'เหลือเพียง $stock ชิ้น!' : 'Only $stock left!';

  String get outOfStockBadge => isThai ? 'สินค้าหมด' : 'Out of stock';

  String discountPill(int percent) => isThai ? 'ลด $percent%' : '-$percent%';

  String saveBadge(String amount) =>
      isThai ? 'ประหยัด $amount' : 'Save $amount';

  String reviewsCountLabel(int count) =>
      isThai ? '$count รีวิว' : '$count reviews';

  String get productDetailsTitle =>
      isThai ? 'รายละเอียดสินค้า' : 'Product Details';

  String get quantityLabel =>
      isThai ? 'จำนวน / Quantity' : 'Quantity';

  String get tabOverview => isThai ? 'รายละเอียด' : 'Overview';

  String get tabShippingAndReturns =>
      isThai ? 'การจัดส่ง & คืนสินค้า' : 'Shipping & Returns';

  String tabReviews(int count) =>
      isThai ? 'รีวิวลูกค้า ($count)' : 'Reviews ($count)';

  String get specDimensionsTitle =>
      isThai ? 'ขนาด & น้ำหนัก' : 'Dimensions & Weight';

  String specWeightValue(double weight) =>
      isThai ? 'น้ำหนัก ${weight.toStringAsFixed(0)} กรัม' : 'Weight ${weight.toStringAsFixed(0)} g';

  String get specSkuTitle =>
      isThai ? 'รหัสสินค้า & ขั้นต่ำ' : 'SKU & Min. Order';

  String specMinOrderValue(int minOrder) =>
      isThai ? 'สั่งขั้นต่ำ $minOrder ชิ้น' : 'Min. order $minOrder pcs';

  String get specWarrantyTitle =>
      isThai ? 'การรับประกัน' : 'Warranty';

  String get specShippingTitle =>
      isThai ? 'การจัดส่ง' : 'Shipping';

  String get specReturnPolicyTitle =>
      isThai ? 'นโยบายการคืนสินค้า' : 'Return Policy';

  String get specBarcodeTitle =>
      isThai ? 'บาร์โค้ดมาตรฐาน' : 'Barcode';

  String get trustAuthenticTitle => isThai ? 'แท้ 100%' : '100% Authentic';

  String get trustAuthenticSubtitle =>
      isThai ? 'รับประกันศูนย์แท้' : 'Official Brand';

  String get trustInstallmentTitle => isThai ? 'จัดส่งรวดเร็ว' : 'Fast Dispatch';

  String get trustInstallmentSubtitle =>
      isThai ? 'แพ็กสินค้าปลอดภัย' : 'Secure Packaging';

  String get trustReturnTitle => isThai ? 'เปลี่ยนคืนง่าย' : 'Easy Returns';

  String get trustReturnSubtitle =>
      isThai ? 'ตามเงื่อนไขร้านค้า' : 'Hassle-free Policy';

  String get addToCartButton => isThai ? 'ใส่ตะกร้า' : 'Add to Cart';

  String get buyNowButton => isThai ? 'ซื้อเลย' : 'Buy Now';

  String addedToCartMessage(String title, int qty) => isThai
      ? 'เพิ่ม "$title" ($qty ชิ้น) ลงในตะกร้าแล้ว'
      : 'Added "$title" (×$qty) to your bag';

  String addedToWishlistMessage(String title) => isThai
      ? 'บันทึก "$title" ในรายการโปรดแล้ว'
      : 'Saved "$title" to wishlist';

  String removedFromWishlistMessage(String title) => isThai
      ? 'นำ "$title" ออกจากรายการโปรดแล้ว'
      : 'Removed "$title" from wishlist';

  String get errorStateTitle => isThai
      ? 'ไม่สามารถโหลดข้อมูลสินค้าได้'
      : 'Unable to Load Products';

  String get retryButtonLabel =>
      isThai ? 'ลองใหม่อีกครั้ง' : 'Try Again';

  String get emptyStateTitle => isThai
      ? 'ไม่พบสินค้าที่ตรงกับเงื่อนไข'
      : 'No Matching Products Found';

  String get emptyStateSubtitle => isThai
      ? 'ลองเปลี่ยนคำค้นหา หรือเลือกหมวดหมู่อื่นเพื่อดูสินค้าทั้งหมด'
      : 'Try adjusting your search keywords or clearing active category filters.';

  String get emptyWishlistSubtitle => isThai
      ? 'คุณยังไม่มีสินค้าในรายการโปรด กดปุ่มหัวใจบนการ์ดสินค้าเพื่อบันทึกไว้ดูภายหลัง'
      : 'Your wishlist is empty. Tap the heart icon on any product card to save it here.';

  String get resetFiltersButton =>
      isThai ? 'ล้างตัวกรองทั้งหมด' : 'Reset Filters';

  String get settingsSheetTitle =>
      isThai ? 'ตั้งค่าการแสดงผล & ภาษา' : 'Display & Language Settings';

  String get themeSectionTitle =>
      isThai ? 'โหมดสีหน้าจอ (Theme Mode)' : 'Appearance (Theme Mode)';

  String get themeLightLabel => isThai ? 'โหมดสว่าง (Light)' : 'Light Mode';

  String get themeDarkLabel => isThai ? 'โหมดมืด (Dark)' : 'Dark Mode';

  String get themeSystemLabel =>
      isThai ? 'ตามระบบอุปกรณ์ (System)' : 'System Default';

  String get languageSectionTitle =>
      isThai ? 'ภาษาที่แสดงผล (Language)' : 'Application Language';

  String get languageThaiLabel => 'ภาษาไทย (TH)';

  String get languageEnglishLabel => 'English (EN)';

  String wishlistStorageSummary(int count) => isThai
      ? 'บันทึกสินค้าในฐานข้อมูล Hive แล้ว $count รายการ'
      : '$count product(s) persisted in local Hive storage';

  String get clearWishlistButton =>
      isThai ? 'ล้างรายการโปรด' : 'Clear Wishlist';

  String get noReviewsMessage => isThai
      ? 'ยังไม่มีรีวิวสำหรับสินค้านี้'
      : 'No customer reviews for this product yet.';
}