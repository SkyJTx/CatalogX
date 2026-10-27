import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'constants.dart';
import 'keys.dart';
import 'repo/dio_product_repository.dart';
import 'repo/hive_local_storage_repository.dart';
import 'repo/local_storage_repository.dart';
import 'repo/product_repository.dart';
import 'router.dart';
import 'ui/services/messenger_service.dart';
import 'ui/services/navigator_service.dart';

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
            headers: const <String, Object?>{'Accept': 'application/json'},
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
      final settingsBox = await Hive.openBox<dynamic>(
        StorageConstants.settingsBox,
      );
      final wishlistBox = await Hive.openBox<dynamic>(
        StorageConstants.wishlistBox,
      );
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