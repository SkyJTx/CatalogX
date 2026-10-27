import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:material_ui/material_ui.dart';

import '/interfaces/local_storage_repository.dart';
import '/models/product.dart';
import '/state/locale_notifier.dart';
import '/ui/services/messenger_service.dart';

class WishlistNotifier extends Notifier<Map<int, Product>> {
  final LocalStorageRepository _storageRepository;
  final MessengerService _messengerService;

  WishlistNotifier({
    required this._storageRepository,
    required this._messengerService,
  });

  @override
  Map<int, Product> build() {
    return _storageRepository.getWishlistProducts();
  }

  bool isWishlisted(int productId) => state.containsKey(productId);

  Future<void> toggle(Product product) async {
    final current = Map<int, Product>.from(state);
    final wasSaved = current.containsKey(product.id);

    if (wasSaved) {
      current.remove(product.id);
      state = current;
      await _storageRepository.removeWishlistProduct(product.id);
    } else {
      current[product.id] = product;
      state = current;
      await _storageRepository.saveWishlistProduct(product);
    }

    final strings = ref.read(appStringsProvider);
    _showFeedback(
      wasSaved
          ? strings.removedFromWishlistMessage(product.title)
          : strings.addedToWishlistMessage(product.title),
    );
  }

  Future<void> clearAll() async {
    state = const <int, Product>{};
    await _storageRepository.clearWishlist();
  }

  void _showFeedback(String text) {
    if (!_messengerService.isMessengerAvailable) {
      return;
    }
    _messengerService.messenger.clearSnackBars();
    _messengerService.showMessage(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

final wishlistProvider = NotifierProvider<WishlistNotifier, Map<int, Product>>(
  () => WishlistNotifier(
    storageRepository: GetIt.I<LocalStorageRepository>(),
    messengerService: GetIt.I<MessengerService>(),
  ),
);

class CartCountNotifier extends Notifier<int> {
  final MessengerService _messengerService;

  CartCountNotifier({required this._messengerService});

  @override
  int build() => 2;

  void addItems(Product product, {int quantity = 1}) {
    state = state + quantity;
    if (!_messengerService.isMessengerAvailable) {
      return;
    }
    final strings = ref.read(appStringsProvider);
    _messengerService.messenger.clearSnackBars();
    _messengerService.showMessage(
      SnackBar(
        content: Text(strings.addedToCartMessage(product.title, quantity)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

final cartCountProvider = NotifierProvider<CartCountNotifier, int>(
  () => CartCountNotifier(
    messengerService: GetIt.I<MessengerService>(),
  ),
);
