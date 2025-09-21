import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(const ThemeState()) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt('theme_mode') ?? 0;
    final accentColorIndex = prefs.getInt('accent_color') ?? 0;

    state = state.copyWith(
      themeMode: AppThemeMode.values[themeModeIndex],
      accentColor: AppTheme.accentColors[accentColorIndex],
    );
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', mode.index);

    state = state.copyWith(themeMode: mode);
  }

  Future<void> setAccentColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    final colorIndex = AppTheme.accentColors.indexOf(color);
    await prefs.setInt('accent_color', colorIndex);

    state = state.copyWith(accentColor: color);
  }

  ThemeData get currentTheme =>
      AppTheme.getTheme(state.themeMode, state.accentColor);
}

class ThemeState {
  final AppThemeMode themeMode;
  final Color accentColor;

  const ThemeState({
    this.themeMode = AppThemeMode.dark,
    this.accentColor = const Color(0xFF6366F1),
  });

  ThemeState copyWith({AppThemeMode? themeMode, Color? accentColor}) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      accentColor: accentColor ?? this.accentColor,
    );
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});

final currentThemeProvider = Provider<ThemeData>((ref) {
  final themeState = ref.watch(themeProvider);
  return AppTheme.getTheme(themeState.themeMode, themeState.accentColor);
});
