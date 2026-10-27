import 'package:get_it/get_it.dart';

import 'keys.dart';
import 'router.dart';
import 'ui/services/messenger_service.dart';
import 'ui/services/navigator_service.dart';

void inject() async {
  GetIt.I.registerSingleton<MessengerService>(
    MessengerService(scaffoldMessengerKey: scaffoldMessengerKey),
  );
  GetIt.I.registerSingleton<NavigatorService>(
    NavigatorService(navigatorKey: navigatorKey, router: router),
  );
}