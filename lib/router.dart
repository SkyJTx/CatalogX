import 'package:go_router/go_router.dart';
import 'keys.dart';

import 'ui/presentations/home/home.dart';

final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeWidget(),
    ),
  ],
);