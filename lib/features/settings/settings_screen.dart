import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/theme_provider.dart';
import '../../theme/app_theme.dart';
import '../../services/storage_service.dart';
import '../../services/search_service.dart';
import 'widgets/theme_selector.dart';
import 'widgets/accent_color_selector.dart';
import 'widgets/settings_tile.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String? _githubToken;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final storageService = ref.read(storageServiceProvider);
    final token = await storageService.getGitHubToken();
    
    if (mounted) {
      setState(() {
        _githubToken = token;
        _isLoading = false;
      });
    }
  }

  Future<void> _updateGitHubToken(String? token) async {
    final storageService = ref.read(storageServiceProvider);
    await storageService.setGitHubToken(token);
    
    setState(() {
      _githubToken = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeState = ref.watch(themeProvider);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  // Header
                  SliverAppBar(
                    expandedHeight: 120,
                    floating: false,
                    pinned: true,
                    backgroundColor: theme.colorScheme.surface,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        'Settings',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.primaryColor.withOpacity(0.1),
                              theme.primaryColor.withOpacity(0.05),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Settings Content
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Appearance Section
                        _buildSectionHeader('Appearance', theme),
                        const SizedBox(height: 12),
                        
                        SettingsTile(
                          icon: Icons.palette_rounded,
                          title: 'Theme',
                          subtitle: _getThemeName(themeState.themeMode),
                          onTap: () => _showThemeSelector(context),
                        ),
                        
                        SettingsTile(
                          icon: Icons.color_lens_rounded,
                          title: 'Accent Color',
                          subtitle: 'Customize app colors',
                          onTap: () => _showAccentColorSelector(context),
                          trailing: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: themeState.accentColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.outline,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // GitHub Section
                        _buildSectionHeader('GitHub', theme),
                        const SizedBox(height: 12),
                        
                        SettingsTile(
                          icon: Icons.key_rounded,
                          title: 'Personal Access Token',
                          subtitle: _githubToken != null 
                              ? 'Token configured'
                              : 'Add token for higher rate limits',
                          onTap: () => _showTokenDialog(context),
                          trailing: _githubToken != null
                              ? Icon(
                                  Icons.check_circle_rounded,
                                  color: theme.colorScheme.primary,
                                )
                              : Icon(
                                  Icons.add_circle_outline_rounded,
                                  color: theme.colorScheme.outline,
                                ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Data Section
                        _buildSectionHeader('Data', theme),
                        const SizedBox(height: 12),
                        
                        SettingsTile(
                          icon: Icons.history_rounded,
                          title: 'Clear Search History',
                          subtitle: 'Remove all search history',
                          onTap: () => _clearSearchHistory(context),
                        ),
                        
                        SettingsTile(
                          icon: Icons.favorite_rounded,
                          title: 'Clear Favorites',
                          subtitle: 'Remove all favorite items',
                          onTap: () => _clearFavorites(context),
                        ),
                        
                        SettingsTile(
                          icon: Icons.cached_rounded,
                          title: 'Clear Cache',
                          subtitle: 'Remove cached data',
                          onTap: () => _clearCache(context),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // About Section
                        _buildSectionHeader('About', theme),
                        const SizedBox(height: 12),
                        
                        SettingsTile(
                          icon: Icons.info_rounded,
                          title: 'App Version',
                          subtitle: '1.0.0',
                          onTap: null,
                        ),
                        
                        SettingsTile(
                          icon: Icons.privacy_tip_rounded,
                          title: 'Privacy Policy',
                          subtitle: 'View our privacy policy',
                          onTap: () => _showPrivacyPolicy(context),
                        ),
                        
                        SettingsTile(
                          icon: Icons.description_rounded,
                          title: 'Terms of Service',
                          subtitle: 'View terms and conditions',
                          onTap: () => _showTermsOfService(context),
                        ),
                        
                        const SizedBox(height: 32),
                      ]),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.primaryColor,
      ),
    ).animate().fadeIn(duration: 300.ms).slideX();
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

  void _showThemeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ThemeSelector(),
    );
  }

  void _showAccentColorSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AccentColorSelector(),
    );
  }

  void _showTokenDialog(BuildContext context) {
    final controller = TextEditingController(text: _githubToken ?? '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('GitHub Token'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your GitHub Personal Access Token for higher rate limits.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Token',
                hintText: 'ghp_...',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _updateGitHubToken(controller.text.trim().isEmpty ? null : controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _clearSearchHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Search History'),
        content: const Text('Are you sure you want to clear all search history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(searchProvider.notifier).clearSearchHistory();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search history cleared')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _clearFavorites(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Favorites'),
        content: const Text('Are you sure you want to clear all favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final storageService = ref.read(storageServiceProvider);
              await storageService.clearFavorites();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Favorites cleared')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _clearCache(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('Are you sure you want to clear all cached data?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final storageService = ref.read(storageServiceProvider);
              await storageService.clearCache();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    // TODO: Implement privacy policy screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy Policy - Coming Soon')),
    );
  }

  void _showTermsOfService(BuildContext context) {
    // TODO: Implement terms of service screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Terms of Service - Coming Soon')),
    );
  }
}
