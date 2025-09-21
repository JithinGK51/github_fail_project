import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

enum AppThemeMode { light, dark, system, hacker, kaliLinux }

class AppTheme {
  static const String _fontFamily = 'Inter';

  // Custom accent colors
  static const List<Color> accentColors = [
    Color(0xFF6366F1), // Indigo
    Color(0xFF8B5CF6), // Purple
    Color(0xFFEC4899), // Pink
    Color(0xFFEF4444), // Red
    Color(0xFFF59E0B), // Amber
    Color(0xFF10B981), // Emerald
    Color(0xFF06B6D4), // Cyan
    Color(0xFF3B82F6), // Blue
    Color(0xFF00FF00), // Matrix Green
    Color(0xFF00FFFF), // Cyan Matrix
    Color(0xFFFF00FF), // Magenta
    Color(0xFFFF6B35), // Orange
  ];

  static ThemeData getLightTheme(Color accentColor) {
    return FlexThemeData.light(
      scheme: FlexScheme.material,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 7,
      appBarStyle: FlexAppBarStyle.primary,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 10,
        blendOnColors: false,
        useTextTheme: true,
        useM2StyleDividerInM3: true,
        alignedDropdown: true,
        useInputDecoratorThemeInDialogs: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      fontFamily: _fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentColor,
        brightness: Brightness.light,
      ),
    );
  }

  static ThemeData getDarkTheme(Color accentColor) {
    return FlexThemeData.dark(
      scheme: FlexScheme.material,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 13,
      appBarStyle: FlexAppBarStyle.primary,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 20,
        useTextTheme: true,
        useM2StyleDividerInM3: true,
        alignedDropdown: true,
        useInputDecoratorThemeInDialogs: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      swapLegacyOnMaterial3: true,
      fontFamily: _fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accentColor,
        brightness: Brightness.dark,
      ),
    );
  }

  static ThemeData getHackerTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Courier New',
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00FF00),
        secondary: Color(0xFF00FFFF),
        surface: Color(0xFF000000),
        background: Color(0xFF000000),
        error: Color(0xFFFF0000),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onSurface: Color(0xFF00FF00),
        onBackground: Color(0xFF00FF00),
        onError: Color(0xFF000000),
      ),
      scaffoldBackgroundColor: const Color(0xFF000000),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF000000),
        foregroundColor: Color(0xFF00FF00),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Courier New',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF00FF00),
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF001100),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF00FF00), width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00FF00),
          foregroundColor: const Color(0xFF000000),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Courier New',
          color: Color(0xFF00FF00),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Courier New',
          color: Color(0xFF00FF00),
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Courier New',
          color: Color(0xFF00FF00),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Courier New',
          color: Color(0xFF00FF00),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Courier New',
          color: Color(0xFF00FF00),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Courier New',
          color: Color(0xFF00FF00),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Courier New',
          color: Color(0xFF00FF00),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Courier New',
          color: Color(0xFF00FF00),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Courier New',
          color: Color(0xFF00FF00),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Courier New',
          color: Color(0xFF00FF00),
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Courier New',
          color: Color(0xFF00FF00),
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Courier New',
          color: Color(0xFF00FF00),
          fontSize: 12,
        ),
      ),
    );
  }

  static ThemeData getKaliLinuxTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Ubuntu Mono',
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00BFFF),
        secondary: Color(0xFF00FFFF),
        surface: Color(0xFF0A0A0A),
        background: Color(0xFF0A0A0A),
        error: Color(0xFFFF4444),
        onPrimary: Color(0xFF000000),
        onSecondary: Color(0xFF000000),
        onSurface: Color(0xFF00BFFF),
        onBackground: Color(0xFF00BFFF),
        onError: Color(0xFF000000),
      ),
      scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0A0A0A),
        foregroundColor: Color(0xFF00BFFF),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Ubuntu Mono',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF00BFFF),
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1A1A2E),
        elevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF00BFFF), width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00BFFF),
          foregroundColor: const Color(0xFF000000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Ubuntu Mono',
          color: Color(0xFF00BFFF),
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Ubuntu Mono',
          color: Color(0xFF00BFFF),
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Ubuntu Mono',
          color: Color(0xFF00BFFF),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Ubuntu Mono',
          color: Color(0xFF00BFFF),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Ubuntu Mono',
          color: Color(0xFF00BFFF),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Ubuntu Mono',
          color: Color(0xFF00BFFF),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Ubuntu Mono',
          color: Color(0xFF00BFFF),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Ubuntu Mono',
          color: Color(0xFF00BFFF),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Ubuntu Mono',
          color: Color(0xFF00BFFF),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Ubuntu Mono',
          color: Color(0xFF00BFFF),
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Ubuntu Mono',
          color: Color(0xFF00BFFF),
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Ubuntu Mono',
          color: Color(0xFF00BFFF),
          fontSize: 12,
        ),
      ),
    );
  }

  static ThemeData getTheme(AppThemeMode mode, Color accentColor) {
    switch (mode) {
      case AppThemeMode.light:
        return getLightTheme(accentColor);
      case AppThemeMode.dark:
        return getDarkTheme(accentColor);
      case AppThemeMode.hacker:
        return getHackerTheme();
      case AppThemeMode.kaliLinux:
        return getKaliLinuxTheme();
      case AppThemeMode.system:
        return getDarkTheme(accentColor); // Default to dark for system
    }
  }
}
