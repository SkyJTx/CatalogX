import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:material_ui/material_ui.dart';

import '/models/product.dart';
import '/interfaces/local_storage_repository.dart';
import '/ui/services/messenger_service.dart';
import 'locale_notifier.dart';

class WishlistNotifier extends Notifier<Map<int, Product>> {
  @override
  Map<int, Product> build() {
    if (GetIt.I.isRegistered<LocalStorageRepository>()) {
      return GetIt.I<LocalStorageRepository>().getWishlistProducts();
    }
    return const <int, Product>{};
  }

  bool isWishlisted(int productId) => state.containsKey(productId);

  Future<void> toggle(Product product) async {
    final next = Map<int, Product>.from(state);
    final exists = next.containsKey(product.id);
    if (exists) {
      next.remove(product.id);
      state = next;
      if (GetIt.I.isRegistered<LocalStorageRepository>()) {
        await GetIt.I<LocalStorageRepository>().removeWishlistProduct(
          product.id,
        );
      }
    } else {
      next[product.id] = product;
      state = next;
      if (GetIt.I.isRegistered<LocalStorageRepository>()) {
        await GetIt.I<LocalStorageRepository>().saveWishlistProduct(product);
      }
    }

    _showFeedback(
      exists
          ? ref.read(appStringsProvider).removedFromWishlistMessage(product.title)
          : ref.read(appStringsProvider).addedToWishlistMessage(product.title),
    );
  }

  Future<void> clearAll() async {
    state = const <int, Product>{};
    if (GetIt.I.isRegistered<LocalStorageRepository>()) {
      await GetIt.I<LocalStorageRepository>().clearWishlist();
    }
  }

  void _showFeedback(String text) {
    if (!GetIt.I.isRegistered<MessengerService>()) return;
    final messengerService = GetIt.I<MessengerService>();
    if (!messengerService.isMessengerAvailable) return;
    messengerService.messenger.hideCurrentSnackBar();
    messengerService.showMessage(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

final wishlistProvider = NotifierProvider<WishlistNotifier, Map<int, Product>>(
  WishlistNotifier.new,
);

class CartCountNotifier extends Notifier<int> {
  @override
  int build() => 2;

  void addItems(Product product, {int quantity = 1}) {
    state = state + quantity;
    if (!GetIt.I.isRegistered<MessengerService>()) return;
    final messengerService = GetIt.I<MessengerService>();
    if (!messengerService.isMessengerAvailable) return;
    final strings = ref.read(appStringsProvider);
    messengerService.messenger.hideCurrentSnackBar();
    messengerService.showMessage(
      SnackBar(
        content: Text(strings.addedToCartMessage(product.title, quantity)),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

final cartCountProvider = NotifierProvider<CartCountNotifier, int>(
  CartCountNotifier.new,
);