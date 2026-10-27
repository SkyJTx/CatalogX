import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'constants.dart';
import 'interfaces/local_storage_repository.dart';
import 'interfaces/product_repository.dart';
import 'keys.dart';
import 'models/adapters/product_adapter.dart';
import 'models/adapters/product_dimensions_adapter.dart';
import 'models/adapters/product_meta_adapter.dart';
import 'models/adapters/product_review_adapter.dart';
import 'models/product.dart';
import 'models/product_dimensions.dart';
import 'models/product_meta.dart';
import 'models/product_review.dart';
import 'repo/dio_product_repository.dart';
import 'repo/hive_local_storage_repository.dart';
import 'router.dart';
import 'ui/services/messenger_service.dart';
import 'ui/services/navigator_service.dart';

void registerHiveAdapters() {
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter<ProductDimensions>(const ProductDimensionsAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter<ProductReview>(const ProductReviewAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter<ProductMeta>(const ProductMetaAdapter());
  }
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter<Product>(const ProductAdapter());
  }
}

Future<void> inject({
  Dio? dioOverride,
  ProductRepository? productRepositoryOverride,
  LocalStorageRepository? localStorageRepositoryOverride,
}) async {
  final getIt = GetIt.I;

  if (!getIt.isRegistered<Dio>()) {
    final dio = dioOverride ??
        Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: ApiConstants.connectTimeout,
            receiveTimeout: ApiConstants.receiveTimeout,
            headers: const <String, Object?>{
              'Accept': 'application/json',
            },
          ),
        );
    getIt.registerSingleton<Dio>(dio);
  }

  if (!getIt.isRegistered<ProductRepository>()) {
    getIt.registerSingleton<ProductRepository>(
      productRepositoryOverride ?? DioProductRepository(dio: getIt<Dio>()),
    );
  }

  if (!getIt.isRegistered<LocalStorageRepository>()) {
    if (localStorageRepositoryOverride != null) {
      getIt.registerSingleton<LocalStorageRepository>(
        localStorageRepositoryOverride,
      );
    } else {
      await Hive.initFlutter();
      registerHiveAdapters();
      final settingsBox = await Hive.openBox<Object?>(
        StorageConstants.settingsBox,
      );
      Box<Product> wishlistBox;
      try {
        wishlistBox = await Hive.openBox<Product>(
          StorageConstants.wishlistBox,
        );
      } catch (_) {
        await Hive.deleteBoxFromDisk(StorageConstants.wishlistBox);
        wishlistBox = await Hive.openBox<Product>(
          StorageConstants.wishlistBox,
        );
      }
      getIt.registerSingleton<LocalStorageRepository>(
        HiveLocalStorageRepository(
          settingsBox: settingsBox,
          wishlistBox: wishlistBox,
        ),
      );
    }
  }

  if (!getIt.isRegistered<MessengerService>()) {
    getIt.registerSingleton<MessengerService>(
      MessengerService(scaffoldMessengerKey: scaffoldMessengerKey),
    );
  }

  if (!getIt.isRegistered<NavigatorService>()) {
    getIt.registerSingleton<NavigatorService>(
      NavigatorService(navigatorKey: navigatorKey, router: router),
    );
  }
}
