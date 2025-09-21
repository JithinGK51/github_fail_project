import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppConfig {
  static const String appName = 'GitHub Explore';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String appDescription =
      'Discover amazing GitHub repositories and developers';

  // Google Play Store Configuration
  static const String packageName = 'com.monarch.gitverse.gitverse';
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=$packageName';

  // App Store Configuration (for future iOS release)
  static const String appStoreUrl =
      'https://apps.apple.com/app/github-explore/id123456789';

  // Privacy and Legal
  static const String privacyPolicyUrl =
      'https://github.com/your-username/github-explore/blob/main/PRIVACY.md';
  static const String termsOfServiceUrl =
      'https://github.com/your-username/github-explore/blob/main/TERMS.md';
  static const String supportEmail = 'support@github-explore.com';

  // Social Media
  static const String githubUrl =
      'https://github.com/your-username/github-explore';
  static const String twitterUrl = 'https://twitter.com/github_explore';

  // Feature Flags
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enableBetaFeatures = false;

  // Rate Limiting
  static const int maxSearchRequestsPerMinute = 10;
  static const int maxSearchRequestsPerHour = 100;

  // Cache Configuration
  static const Duration searchCacheDuration = Duration(hours: 1);
  static const Duration userCacheDuration = Duration(hours: 24);
  static const Duration repositoryCacheDuration = Duration(hours: 6);

  // UI Configuration
  static const double maxContentWidth = 600.0;
  static const int maxSearchResults = 100;
  static const int maxSearchHistory = 50;
  static const int maxFavorites = 1000;

  // Animation Configuration
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);

  // Network Configuration
  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 10);
  static const int maxRetryAttempts = 3;

  // Security Configuration
  static const bool enableCertificatePinning = false;
  static const bool enableBiometricAuth = false;
  static const bool enableAppLock = false;

  // Performance Configuration
  static const int maxImageCacheSize = 100;
  static const Duration imageCacheDuration = Duration(days: 7);
  static const int maxSearchSuggestions = 10;

  // Accessibility Configuration
  static const bool enableHighContrast = false;
  static const bool enableLargeText = false;
  static const bool enableScreenReader = true;

  // Development Configuration
  static const bool enableDebugMode = false;
  static const bool enableLogging = true;
  static const bool enablePerformanceMonitoring = true;

  // App Store Optimization
  static const List<String> keywords = [
    'github',
    'repository',
    'developer',
    'code',
    'programming',
    'open source',
    'git',
    'search',
    'explore',
    'discover',
  ];

  static const List<String> categories = [
    'Developer Tools',
    'Productivity',
    'Education',
  ];

  static const String shortDescription =
      'Discover and explore GitHub repositories and developers';
  static const String longDescription = '''
GitHub Explore is the ultimate app for discovering amazing GitHub repositories and developers. 

Features:
• Search users and repositories
• Beautiful Material 3 design
• Multiple themes including Hacker and Kali Linux
• Favorites system
• Search history
• Offline caching
• Rate limit handling
• Smooth animations

Perfect for developers, students, and anyone interested in open source projects.
''';

  // System UI Configuration
  static void configureSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  // App Information
  static Map<String, dynamic> getAppInfo() {
    return {
      'name': appName,
      'version': appVersion,
      'buildNumber': appBuildNumber,
      'description': appDescription,
      'packageName': packageName,
      'platform': 'android',
    };
  }
}
