import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

class AppPalette {
  const AppPalette._();

  static const Color primaryLight = Color(0xFF1D4ED8);
  static const Color primaryDark = Color(0xFF3B82F6);
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color darkBackground = Color(0xFF0B0F19);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color darkCard = Color(0xFF131B2E);
  static const Color lightImageWell = Color(0xFFF1F5F9);
  static const Color darkImageWell = Color(0xFF1E293B);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color darkBorder = Color(0xFF1E293B);
  static const Color discountRose = Color(0xFFE11D48);
  static const Color discountRoseBgLight = Color(0xFFFFE4E6);
  static const Color discountRoseBgDark = Color(0xFF4C0519);
  static const Color inStockEmerald = Color(0xFF059669);
  static const Color inStockEmeraldBgLight = Color(0xFFD1FAE5);
  static const Color inStockEmeraldBgDark = Color(0xFF064E3B);
  static const Color starAmber = Color(0xFFD97706);
  static const Color starAmberDark = Color(0xFFFBBF24);
}

class AppTheme {
  const AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final baseScheme = ColorScheme.fromSeed(
      seedColor: isDark ? AppPalette.primaryDark : AppPalette.primaryLight,
      brightness: brightness,
    ).copyWith(
      primary: isDark ? AppPalette.primaryDark : AppPalette.primaryLight,
      surface: isDark ? AppPalette.darkBackground : AppPalette.lightBackground,
      surfaceContainerLow: isDark ? AppPalette.darkCard : AppPalette.lightCard,
      surfaceContainerHighest:
          isDark ? AppPalette.darkImageWell : AppPalette.lightImageWell,
      outlineVariant: isDark ? AppPalette.darkBorder : AppPalette.lightBorder,
      error: AppPalette.discountRose,
      tertiary: AppPalette.inStockEmerald,
      secondary: isDark ? AppPalette.starAmberDark : AppPalette.starAmber,
    );

    final baseTextTheme = GoogleFonts.ibmPlexSansThaiTextTheme(
      ThemeData(brightness: brightness).textTheme,
    );
    final headingFont = GoogleFonts.plusJakartaSans().fontFamily;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: baseScheme,
      scaffoldBackgroundColor: baseScheme.surface,
      textTheme: baseTextTheme.copyWith(
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          fontFamily: headingFont,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          fontFamily: headingFont,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: AppBarThemeData(
        backgroundColor: isDark ? AppPalette.darkCard : AppPalette.lightCard,
        foregroundColor: baseScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: isDark ? AppPalette.darkCard : AppPalette.lightCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: baseScheme.outlineVariant, width: 1),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? AppPalette.darkCard : AppPalette.lightCard,
        selectedColor: baseScheme.primary,
        side: BorderSide(color: baseScheme.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: isDark ? AppPalette.darkCard : AppPalette.lightCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: baseScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: baseScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: baseScheme.primary, width: 1.5),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? AppPalette.darkCard : AppPalette.lightCard,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }
}

final themeColor = AppTheme.light.colorScheme;
final themeData = AppTheme.light;