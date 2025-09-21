class AppConstants {
  // App Information
  static const String appName = 'GitHub Explore';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'Discover amazing GitHub repositories and developers';

  // API Configuration
  static const String githubApiBaseUrl = 'https://api.github.com';
  static const int defaultPageSize = 30;
  static const int maxSearchHistory = 50;
  static const int maxCacheItems = 20;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;

  // Search Configuration
  static const int minSearchLength = 2;
  static const int maxSearchLength = 100;
  static const Duration searchDebounceDelay = Duration(milliseconds: 500);

  // Rate Limiting
  static const int unauthenticatedRateLimit = 60;
  static const int authenticatedRateLimit = 5000;

  // Storage Keys
  static const String themeModeKey = 'theme_mode';
  static const String accentColorKey = 'accent_color';
  static const String searchHistoryKey = 'search_history';
  static const String favoritesKey = 'favorites';
  static const String cacheKey = 'search_cache';
  static const String githubTokenKey = 'github_token';
}
