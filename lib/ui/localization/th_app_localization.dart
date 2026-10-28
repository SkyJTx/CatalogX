import 'package:intl/intl.dart';

import '/interfaces/app_localization.dart';
import '/models/app_language.dart';
import '/models/catalog_sort_option.dart';

class ThAppLocalization implements AppLocalization {
  const ThAppLocalization();

  static final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: r'$',
    decimalDigits: 2,
  );
  static final DateFormat _dateFormatter = DateFormat('dd MMM yyyy');

  @override
  AppLanguage get language => AppLanguage.th;

  @override
  bool get isThai => true;

  @override
  String formatPrice(double value) => _currencyFormatter.format(value);

  @override
  String formatDate(DateTime date) => _dateFormatter.format(date);

  @override
  String get appTitle => 'CatalogX';

  @override
  String get appSubtitle => 'คัดสรรสินค้าดีไซน์และคุณภาพ';

  @override
  String get pullToRefreshHint => 'เลื่อนลงเพื่อรีเฟรชรายการ';

  @override
  String get searchHint => 'ค้นหาชื่อสินค้า แบรนด์ หรือหมวดหมู่...';

  @override
  String get allCategoriesLabel => 'ทั้งหมด';

  @override
  String wishlistFilterLabel(int count) => 'รายการที่บันทึก ($count)';

  @override
  String showingResultsCount(int loaded, int total) =>
      'แสดง $loaded จาก $total รายการ';

  @override
  String pageProgressText({
    required int currentPage,
    required int totalPages,
    required int loaded,
    required int total,
  }) =>
      'หน้า $currentPage จาก $totalPages - โหลดแล้ว $loaded จาก $total รายการ';

  @override
  String get loadMoreButton => 'ดูสินค้าเพิ่มเติม';

  @override
  String get loadingMoreButton => 'กำลังโหลดเพิ่มเติม...';

  @override
  String get allProductsLoaded => 'แสดงสินค้าครบทุกรายการแล้ว';

  @override
  String sortLabel(CatalogSortOption option) => switch (option) {
    CatalogSortOption.popular => 'แนะนำ',
    CatalogSortOption.priceLowToHigh => 'ราคาต่ำไปสูง',
    CatalogSortOption.priceHighToLow => 'ราคาสูงไปต่ำ',
    CatalogSortOption.highestRated => 'คะแนนสูงสุด',
    CatalogSortOption.biggestDiscount => 'ส่วนลดสูงสุด',
  };

  @override
  String inStockBadge(int stock) => 'มีสินค้า $stock ชิ้น';

  @override
  String lowStockBadge(int stock) => 'เหลือเพียง $stock ชิ้น';

  @override
  String get outOfStockBadge => 'สินค้าหมด';

  @override
  String discountPill(int percent) => 'ลด $percent%';

  @override
  String saveBadge(String amount) => 'ประหยัด $amount';

  @override
  String reviewsCountLabel(int count) => '$count รีวิว';

  @override
  String get productDetailsTitle => 'รายละเอียดสินค้า';

  @override
  String get quantityLabel => 'จำนวน';

  @override
  String get tabOverview => 'ข้อมูลจำเพาะ';

  @override
  String get tabShippingAndReturns => 'การจัดส่งและการดูแล';

  @override
  String tabReviews(int count) => 'รีวิว ($count)';

  @override
  String get specDimensionsTitle => 'ขนาดและน้ำหนัก';

  @override
  String specWeightValue(double weight) =>
      'น้ำหนัก ${weight.toStringAsFixed(0)} กรัม';

  @override
  String get specSkuTitle => 'รหัสสินค้าและจำนวนขั้นต่ำ';

  @override
  String specMinOrderValue(int minOrder) => 'สั่งขั้นต่ำ $minOrder ชิ้น';

  @override
  String get specWarrantyTitle => 'การรับประกัน';

  @override
  String get specShippingTitle => 'การจัดส่ง';

  @override
  String get specReturnPolicyTitle => 'การคืนสินค้า';

  @override
  String get specBarcodeTitle => 'บาร์โค้ด';

  @override
  String get trustAuthenticTitle => 'รับรองของแท้';

  @override
  String get trustAuthenticSubtitle => 'คัดสรรจากแบรนด์ผู้ผลิตโดยตรง';

  @override
  String get trustInstallmentTitle => 'จัดส่งอย่างพิถีพิถัน';

  @override
  String get trustInstallmentSubtitle => 'บรรจุภัณฑ์นิรภัยพร้อมประกันขนส่ง';

  @override
  String get trustReturnTitle => 'คืนสินค้าได้สะดวก';

  @override
  String get trustReturnSubtitle => 'เงื่อนไขชัดเจนและโปร่งใส';

  @override
  String get addToCartButton => 'เพิ่มลงถุงช้อปปิ้ง';

  @override
  String get buyNowButton => 'สั่งซื้อทันที';

  @override
  String addedToCartMessage(String title, int qty) =>
      'เพิ่ม "$title" ($qty ชิ้น) ลงในถุงช้อปปิ้งแล้ว';

  @override
  String addedToWishlistMessage(String title) =>
      'บันทึก "$title" ในรายการที่ชอบแล้ว';

  @override
  String removedFromWishlistMessage(String title) =>
      'นำ "$title" ออกจากรายการที่ชอบแล้ว';

  @override
  String get errorStateTitle => 'ไม่สามารถโหลดข้อมูลสินค้าได้';

  @override
  String get retryButtonLabel => 'ลองใหม่อีกครั้ง';

  @override
  String get emptyStateTitle => 'ไม่พบสินค้าที่ค้นหา';

  @override
  String get emptyStateSubtitle =>
      'ลองปรับเปลี่ยนคำค้นหา หรือล้างตัวกรองหมวดหมู่ที่เลือกไว้';

  @override
  String get emptyWishlistSubtitle =>
      'ยังไม่มีรายการที่บันทึกไว้ กดสัญลักษณ์หัวใจบนสินค้าเพื่อเก็บไว้ดูภายหลัง';

  @override
  String get resetFiltersButton => 'ล้างตัวกรองทั้งหมด';

  @override
  String get settingsSheetTitle => 'การตั้งค่า';

  @override
  String get themeSectionTitle => 'โหมดการแสดงผล';

  @override
  String get themeLightLabel => 'สว่าง';

  @override
  String get themeDarkLabel => 'มืด';

  @override
  String get themeSystemLabel => 'ตามอุปกรณ์';

  @override
  String get languageSectionTitle => 'ภาษา';

  @override
  String get languageThaiLabel => 'ไทย';

  @override
  String get languageEnglishLabel => 'English';

  @override
  String wishlistStorageSummary(int count) =>
      'บันทึกสินค้าแล้ว $count รายการ';

  @override
  String get clearWishlistButton => 'ล้างรายการที่บันทึก';

  @override
  String get noReviewsMessage => 'ยังไม่มีความคิดเห็นสำหรับสินค้านี้';
}
