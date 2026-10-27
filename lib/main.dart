import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'constants.dart';
import 'di.dart';
import 'keys.dart';
import 'router.dart';
import 'state/theme_notifier.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await inject();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return ResponsiveSizer(
      maxMobileWidth: LayoutConstants.mobileMaxWidth,
      maxTabletWidth: LayoutConstants.tabletMaxWidth,
      builder: (context, orientation, screenType) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: scaffoldMessengerKey,
          title: 'CatalogX',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          routerConfig: router,
          builder: (context, child) {
            return ResponsiveBreakpoints.builder(
              child: child ?? const SizedBox.shrink(),
              breakpoints: const <Breakpoint>[
                Breakpoint(
                  start: 0,
                  end: LayoutConstants.mobileMaxWidth,
                  name: MOBILE,
                ),
                Breakpoint(
                  start: LayoutConstants.tabletStartWidth,
                  end: LayoutConstants.tabletMaxWidth,
                  name: TABLET,
                ),
                Breakpoint(
                  start: LayoutConstants.desktopStartWidth,
                  end: LayoutConstants.desktopMaxWidth,
                  name: DESKTOP,
                ),
                Breakpoint(
                  start: 1921,
                  end: double.infinity,
                  name: '4K',
                ),
              ],
            );
          },
        );
      },
    );
  }
}