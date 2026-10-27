import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

class NavigatorService {
  final GlobalKey<NavigatorState> _navigatorKey;
  final GoRouter _router;

  NavigatorService({
    required this._navigatorKey,
    required this._router,
  });

  bool get isNavigatorAvailable {
    return _navigatorKey.currentState != null;
  }

  GoRouter get router => _router;

  NavigatorState get navigator {
    if (!isNavigatorAvailable) {
      throw Exception('Navigator is not available');
    }
    return _navigatorKey.currentState!;
  }
}
