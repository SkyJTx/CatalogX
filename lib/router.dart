import 'package:go_router/go_router.dart';

import 'keys.dart';
import 'models/product.dart';
import 'ui/presentations/home/home.dart';
import 'ui/presentations/product_detail/product_detail_screen.dart';

final router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeWidget(),
      routes: <RouteBase>[
        GoRoute(
          path: 'products/:id',
          builder: (context, state) {
            final rawId = state.pathParameters['id'] ?? '';
            final productId = int.tryParse(rawId) ?? 0;
            final extraProduct =
                state.extra is Product ? state.extra as Product : null;
            return ProductDetailScreen(
              productId: productId,
              initialProduct: extraProduct,
            );
          },
        ),
      ],
    ),
  ],
);