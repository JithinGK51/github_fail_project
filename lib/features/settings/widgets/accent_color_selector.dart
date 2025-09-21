import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../theme/theme_provider.dart';
import '../../../theme/app_theme.dart';

class AccentColorSelector extends ConsumerWidget {
  const AccentColorSelector({super.key});

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
                Icon(
                  Icons.color_lens_rounded,
                  color: theme.primaryColor,
                ),
                const SizedBox(width: 12),
                Text(
                  'Select Accent Color',
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
          
          // Color Grid
          Padding(
            padding: const EdgeInsets.all(20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: AppTheme.accentColors.length,
              itemBuilder: (context, index) {
                final color = AppTheme.accentColors[index];
                final isSelected = currentTheme.accentColor == color;
                
                return GestureDetector(
                  onTap: () {
                    ref.read(themeProvider.notifier).setAccentColor(color);
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected 
                            ? theme.colorScheme.onSurface
                            : Colors.transparent,
                        width: isSelected ? 3 : 0,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ] : null,
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check_rounded,
                            color: _getContrastColor(color),
                            size: 24,
                          )
                        : null,
                  ),
                ).animate().fadeIn(duration: 300.ms).scale();
              },
            ),
          ),
          
          // Current Color Info
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: currentTheme.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: currentTheme.accentColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: currentTheme.accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Accent Color',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _getColorName(currentTheme.accentColor),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Color _getContrastColor(Color color) {
    // Calculate luminance to determine if we should use black or white text
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  String _getColorName(Color color) {
    // Simple color name mapping
    if (color == const Color(0xFF6366F1)) return 'Indigo';
    if (color == const Color(0xFF8B5CF6)) return 'Purple';
    if (color == const Color(0xFFEC4899)) return 'Pink';
    if (color == const Color(0xFFEF4444)) return 'Red';
    if (color == const Color(0xFFF59E0B)) return 'Amber';
    if (color == const Color(0xFF10B981)) return 'Emerald';
    if (color == const Color(0xFF06B6D4)) return 'Cyan';
    if (color == const Color(0xFF3B82F6)) return 'Blue';
    if (color == const Color(0xFF00FF00)) return 'Matrix Green';
    if (color == const Color(0xFF00FFFF)) return 'Cyan Matrix';
    if (color == const Color(0xFFFF00FF)) return 'Magenta';
    if (color == const Color(0xFFFF6B35)) return 'Orange';
    return 'Custom';
  }
}
