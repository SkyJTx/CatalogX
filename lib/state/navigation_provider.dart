import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '/ui/services/messenger_service.dart';
import '/ui/services/navigator_service.dart';

final navigatorServiceProvider = Provider<NavigatorService>((ref) {
  return GetIt.I<NavigatorService>();
});

final messengerServiceProvider = Provider<MessengerService>((ref) {
  return GetIt.I<MessengerService>();
});
