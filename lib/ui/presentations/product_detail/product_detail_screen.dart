import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:material_ui/material_ui.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/constants.dart';
import '/models/app_language.dart';
import '/models/product.dart';
import '/models/app_exception.dart';
import '/state/locale_notifier.dart';
import '/state/product_detail_provider.dart';
import '/state/wishlist_notifier.dart';
import '/theme.dart';
import '/ui/components/settings_sheet.dart';
import '/ui/components/state_feedback_view.dart';
import '/ui/services/navigator_service.dart';
import 'product_gallery_section.dart';
import 'product_info_section.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final int productId;
  final Product? initialProduct;

  const ProductDetailScreen({
    super.key,
    required this.productId,
    this.initialProduct,
  });

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  late final PageController _pageController;
  int _selectedImageIndex = 0;
  int _quantity = 1;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectImage(int index) {
    setState(() {
      _selectedImageIndex = index;
    });
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final currentLang = ref.watch(localeProvider);
    final strings = ref.watch(appStringsProvider);
    final detailAsync = ref.watch(productDetailProvider(widget.productId));
    final product = detailAsync.value ?? widget.initialProduct;

    final isWide = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
    final horizontalPadding = ResponsiveValue<double>(
      context,
      defaultValue: 16,
      conditionalValues: const <Condition<double>>[
        Condition<double>.equals(name: MOBILE, value: 16),
        Condition<double>.equals(name: TABLET, value: 24),
        Condition<double>.largerThan(name: TABLET, value: 32),
      ],
    ).value;

    final isWishlisted = product != null &&
        ref.watch(
          wishlistProvider.select((map) => map.containsKey(product.id)),
        );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (GetIt.I.isRegistered<NavigatorService>()) {
              final nav = GetIt.I<NavigatorService>();
              if (nav.router.canPop()) {
                nav.router.pop();
                return;
              }
              nav.router.go('/');
            } else {
              Navigator.of(context).maybePop();
            }
          },
          icon: const Icon(LucideIcons.arrowLeft, size: 20),
        ),
        title: Text(
          strings.productDetailsTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Material(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(999),
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () {
                  ref.read(localeProvider.notifier).toggleLanguage();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        LucideIcons.languages,
                        size: 15,
                        color: scheme.primary,
                      ),
                      const Gap(5),
                      Text(
                        currentLang == AppLanguage.th ? 'TH' : 'EN',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: scheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Gap(4),
          if (product != null)
            IconButton(
              onPressed: () {
                ref.read(wishlistProvider.notifier).toggle(product);
              },
              icon: Icon(
                isWishlisted ? Icons.favorite : LucideIcons.heart,
                size: 20,
                color: isWishlisted
                    ? AppPalette.discountRose
                    : scheme.onSurface,
              ),
            ),
          IconButton(
            onPressed: () => SettingsSheet.show(context),
            icon: const Icon(LucideIcons.settings2, size: 20),
          ),
          const Gap(8),
        ],
      ),
      bottomNavigationBar: (!isWide && product != null)
          ? DetailBottomActionBar(
              product: product,
              quantity: _quantity,
              strings: strings,
            )
          : null,
      body: MaxWidthBox(
        maxWidth: LayoutConstants.detailMaxWidth,
        backgroundColor: theme.scaffoldBackgroundColor,
        child: RefreshIndicator(
          onRefresh: () {
            return ref
                .read(productDetailProvider(widget.productId).notifier)
                .refreshProduct();
          },
          child: Builder(
            builder: (context) {
              if (product == null && detailAsync.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (product == null && detailAsync.hasError) {
                final err = detailAsync.error;
                final message = err is AppException
                    ? err.localizedMessage(currentLang)
                    : strings.errorStateTitle;
                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: <Widget>[
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: EdgeInsets.all(horizontalPadding),
                        child: StateFeedbackView.error(
                          title: strings.errorStateTitle,
                          message: message,
                          retryLabel: strings.retryButtonLabel,
                          onRetry: () {
                            ref
                                .read(
                                  productDetailProvider(
                                    widget.productId,
                                  ).notifier,
                                )
                                .refreshProduct();
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }

              if (product == null) {
                return const SizedBox.shrink();
              }

              final gallerySection = ProductGallerySection(
                product: product,
                strings: strings,
                pageController: _pageController,
                selectedIndex: _selectedImageIndex,
                onPageChanged: (idx) {
                  setState(() {
                    _selectedImageIndex = idx;
                  });
                },
                onThumbnailTap: _selectImage,
                showTrustBadgesBelow: isWide,
              );

              final detailsSection = ProductInfoSection(
                product: product,
                strings: strings,
                quantity: _quantity,
                selectedTabIndex: _selectedTabIndex,
                showInlineActionButtons: isWide,
                showBottomTrustBadges: !isWide,
                onQuantityChanged: (nextQty) {
                  final maxStock = product.stock > 0 ? product.stock : 1;
                  setState(() {
                    _quantity = nextQty.clamp(1, maxStock);
                  });
                },
                onTabSelected: (tabIdx) {
                  setState(() {
                    _selectedTabIndex = tabIdx;
                  });
                },
              );

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  16,
                  horizontalPadding,
                  32,
                ),
                child: ResponsiveRowColumn(
                  layout: isWide
                      ? ResponsiveRowColumnType.ROW
                      : ResponsiveRowColumnType.COLUMN,
                  rowCrossAxisAlignment: CrossAxisAlignment.start,
                  columnCrossAxisAlignment: CrossAxisAlignment.stretch,
                  rowSpacing: 28,
                  columnSpacing: 16,
                  children: <ResponsiveRowColumnItem>[
                    ResponsiveRowColumnItem(
                      rowFlex: 5,
                      child: gallerySection,
                    ),
                    ResponsiveRowColumnItem(
                      rowFlex: 6,
                      child: detailsSection,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}