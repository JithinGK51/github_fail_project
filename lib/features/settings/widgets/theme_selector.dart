import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/theme_provider.dart';
import '../../../theme/app_theme.dart';

class ThemeSelector extends ConsumerWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentTheme = ref.watch(themeProvider);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.palette_rounded, color: theme.primaryColor),
                const SizedBox(width: 12),
                Text(
                  'Select Theme',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Theme Options
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children:
                  AppThemeMode.values.map((mode) {
                    final isSelected = currentTheme.themeMode == mode;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? theme.primaryColor.withOpacity(0.1)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              isSelected
                                  ? theme.primaryColor
                                  : theme.colorScheme.outline.withOpacity(0.2),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            ref.read(themeProvider.notifier).setThemeMode(mode);
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Theme Preview
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _getThemeColor(mode),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: theme.colorScheme.outline
                                          .withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    _getThemeIcon(mode),
                                    color: _getThemeIconColor(mode),
                                    size: 20,
                                  ),
                                ),

                                const SizedBox(width: 16),

                                // Theme Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _getThemeName(mode),
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  isSelected
                                                      ? theme.primaryColor
                                                      : theme
                                                          .colorScheme
                                                          .onSurface,
                                            ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _getThemeDescription(mode),
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme.colorScheme.onSurface
                                                  .withOpacity(0.6),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Selection Indicator
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: theme.primaryColor,
                                    size: 24,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ).animate().fadeIn(duration: 300.ms).slideX();
                  }).toList(),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _getThemeName(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
      case AppThemeMode.hacker:
        return 'Hacker';
      case AppThemeMode.kaliLinux:
        return 'Kali Linux';
    }
  }

  String _getThemeDescription(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'Clean and bright interface';
      case AppThemeMode.dark:
        return 'Easy on the eyes';
      case AppThemeMode.system:
        return 'Follows system settings';
      case AppThemeMode.hacker:
        return 'Matrix-style green theme';
      case AppThemeMode.kaliLinux:
        return 'Kali Linux inspired design';
    }
  }

  Color _getThemeColor(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return Colors.white;
      case AppThemeMode.dark:
        return Colors.grey[900]!;
      case AppThemeMode.system:
        return Colors.blue;
      case AppThemeMode.hacker:
        return Colors.black;
      case AppThemeMode.kaliLinux:
        return const Color(0xFF0A0A0A);
    }
  }

  IconData _getThemeIcon(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return Icons.light_mode_rounded;
      case AppThemeMode.dark:
        return Icons.dark_mode_rounded;
      case AppThemeMode.system:
        return Icons.settings_suggest_rounded;
      case AppThemeMode.hacker:
        return Icons.code_rounded;
      case AppThemeMode.kaliLinux:
        return Icons.security_rounded;
    }
  }

  Color _getThemeIconColor(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return Colors.black;
      case AppThemeMode.dark:
        return Colors.white;
      case AppThemeMode.system:
        return Colors.white;
      case AppThemeMode.hacker:
        return const Color(0xFF00FF00);
      case AppThemeMode.kaliLinux:
        return const Color(0xFF00BFFF);
    }
  }
}
