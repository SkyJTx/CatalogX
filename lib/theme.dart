import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

class AppPalette {
  const AppPalette._();

  static const Color primaryLight = Color(0xFF1C1917);
  static const Color primaryDark = Color(0xFFF5F5F4);
  static const Color lightBackground = Color(0xFFFAF8F5);
  static const Color darkBackground = Color(0xFF141210);
  static const Color lightSurfaceLow = Color(0xFFF5F2EB);
  static const Color darkSurfaceLow = Color(0xFF1C1917);
  static const Color lightImageWell = Color(0xFFF3EFEA);
  static const Color darkImageWell = Color(0xFF1F1C19);
  static const Color lightHairline = Color(0xFFE7E2DA);
  static const Color darkHairline = Color(0xFF292524);
  static const Color mutedStoneLight = Color(0xFF78716C);
  static const Color mutedStoneDark = Color(0xFFA8A29E);

  static const Color discountTerracotta = Color(0xFFC2410C);
  static const Color discountTerracottaDark = Color(0xFFFB923C);
  static const Color inStockSage = Color(0xFF3F6212);
  static const Color inStockSageDark = Color(0xFFA3E635);
  static const Color starOchre = Color(0xFFB45309);
  static const Color starOchreDark = Color(0xFFFBBF24);

  static const Color lightCard = lightSurfaceLow;
  static const Color darkCard = darkSurfaceLow;
  static const Color lightBorder = lightHairline;
  static const Color darkBorder = darkHairline;
  static const Color discountRose = discountTerracotta;
  static const Color discountRoseBgLight = Color(0xFFFEE2E2);
  static const Color discountRoseBgDark = Color(0xFF431407);
  static const Color inStockEmerald = inStockSage;
  static const Color inStockEmeraldBgLight = Color(0xFFECFCCB);
  static const Color inStockEmeraldBgDark = Color(0xFF1A2E05);
  static const Color starAmber = starOchre;
  static const Color starAmberDark = starOchreDark;
}

class AppTheme {
  const AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final primaryColor =
        isDark ? AppPalette.primaryDark : AppPalette.primaryLight;
    final onPrimaryColor =
        isDark ? AppPalette.darkBackground : AppPalette.lightBackground;
    final surfaceColor =
        isDark ? AppPalette.darkBackground : AppPalette.lightBackground;
    final onSurfaceColor =
        isDark ? AppPalette.primaryDark : AppPalette.primaryLight;
    final mutedTextColor =
        isDark ? AppPalette.mutedStoneDark : AppPalette.mutedStoneLight;
    final hairlineColor =
        isDark ? AppPalette.darkHairline : AppPalette.lightHairline;

    final baseScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: brightness,
    ).copyWith(
      primary: primaryColor,
      onPrimary: onPrimaryColor,
      surface: surfaceColor,
      onSurface: onSurfaceColor,
      onSurfaceVariant: mutedTextColor,
      surfaceContainerLow:
          isDark ? AppPalette.darkSurfaceLow : AppPalette.lightSurfaceLow,
      surfaceContainerHighest:
          isDark ? AppPalette.darkImageWell : AppPalette.lightImageWell,
      outlineVariant: hairlineColor,
      outline: hairlineColor,
      error: isDark
          ? AppPalette.discountTerracottaDark
          : AppPalette.discountTerracotta,
      tertiary:
          isDark ? AppPalette.inStockSageDark : AppPalette.inStockSage,
      secondary: isDark ? AppPalette.starOchreDark : AppPalette.starOchre,
    );

    final thaiFontFamily = GoogleFonts.anuphan().fontFamily ?? 'Anuphan';
    final interBase = GoogleFonts.interTextTheme(
      ThemeData(brightness: brightness).textTheme,
    );
    final unifiedTextTheme = interBase.apply(
      bodyColor: onSurfaceColor,
      displayColor: onSurfaceColor,
      fontFamilyFallback: <String>[thaiFontFamily],
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: baseScheme,
      scaffoldBackgroundColor: surfaceColor,
      dividerTheme: DividerThemeData(
        color: hairlineColor,
        thickness: 1,
        space: 1,
      ),
      textTheme: unifiedTextTheme.copyWith(
        headlineMedium: unifiedTextTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: -0.5,
          fontFamilyFallback: <String>[thaiFontFamily],
        ),
        titleLarge: unifiedTextTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          fontFamilyFallback: <String>[thaiFontFamily],
        ),
        titleMedium: unifiedTextTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: -0.15,
          fontFamilyFallback: <String>[thaiFontFamily],
        ),
        bodyMedium: unifiedTextTheme.bodyMedium?.copyWith(
          height: 1.45,
          fontFamilyFallback: <String>[thaiFontFamily],
        ),
        bodySmall: unifiedTextTheme.bodySmall?.copyWith(
          color: mutedTextColor,
          fontFamilyFallback: <String>[thaiFontFamily],
        ),
      ),
      appBarTheme: AppBarThemeData(
        backgroundColor: surfaceColor,
        foregroundColor: onSurfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide.none,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor:
            isDark ? AppPalette.darkImageWell : AppPalette.lightImageWell,
        selectedColor: primaryColor,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor:
            isDark ? AppPalette.darkImageWell : AppPalette.lightImageWell,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primaryColor, width: 1),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: onPrimaryColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: onSurfaceColor,
          side: BorderSide(color: hairlineColor, width: 1),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

final themeColor = AppTheme.light.colorScheme;
final themeData = AppTheme.light;
