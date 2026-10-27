import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '/constants.dart';
import '/models/app_exception.dart';
import '/models/product.dart';
import '/state/locale_notifier.dart';
import '/state/product_detail_provider.dart';
import '/ui/components/state_feedback_view.dart';
import '/ui/presentations/product_detail/widgets/detail_bottom_action_bar.dart';
import '/ui/presentations/product_detail/widgets/product_detail_app_bar.dart';
import '/ui/presentations/product_detail/widgets/product_gallery_section.dart';
import '/ui/presentations/product_detail/widgets/product_info_section.dart';

export '/ui/presentations/product_detail/widgets/detail_bottom_action_bar.dart';

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

    return Scaffold(
      appBar: ProductDetailAppBar(product: product),
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
          onRefresh: () => ref
              .read(productDetailProvider(widget.productId).notifier)
              .refreshProduct(),
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
                    : err.toString();
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.72,
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
                  ],
                );
              }

              if (product == null) {
                return const SizedBox.shrink();
              }

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  24,
                  horizontalPadding,
                  isWide ? 48 : 32,
                ),
                child: ResponsiveRowColumn(
                  layout: isWide
                      ? ResponsiveRowColumnType.ROW
                      : ResponsiveRowColumnType.COLUMN,
                  rowCrossAxisAlignment: CrossAxisAlignment.start,
                  rowSpacing: 32,
                  columnSpacing: 24,
                  children: <ResponsiveRowColumnItem>[
                    ResponsiveRowColumnItem(
                      rowFlex: 5,
                      child: ProductGallerySection(
                        product: product,
                        strings: strings,
                        pageController: _pageController,
                        selectedIndex: _selectedImageIndex,
                        onPageChanged: (index) {
                          setState(() {
                            _selectedImageIndex = index;
                          });
                        },
                        onThumbnailTap: _selectImage,
                        showTrustBadgesBelow: isWide,
                      ),
                    ),
                    ResponsiveRowColumnItem(
                      rowFlex: 6,
                      child: ProductInfoSection(
                        product: product,
                        strings: strings,
                        quantity: _quantity,
                        selectedTabIndex: _selectedTabIndex,
                        showInlineActionButtons: isWide,
                        showBottomTrustBadges: !isWide,
                        onQuantityChanged: (nextQty) {
                          setState(() {
                            _quantity = nextQty;
                          });
                        },
                        onTabSelected: (index) {
                          setState(() {
                            _selectedTabIndex = index;
                          });
                        },
                      ),
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
