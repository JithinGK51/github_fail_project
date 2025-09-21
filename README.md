# 🚀 GitHub Explore - Flutter App

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![GitHub API](https://img.shields.io/badge/GitHub_API-181717?style=for-the-badge&logo=github&logoColor=white)](https://docs.github.com/en/rest)

> **⚠️ Project Status: IN PROGRESS** - This is an actively developed Flutter application with advanced GitHub integration features.

## 📱 Overview

**GitHub Explore** is a modern, feature-rich Flutter application that provides a beautiful and intuitive interface for discovering GitHub users and repositories. Built with Material Design 3 principles and powered by the GitHub REST API, it offers a seamless search experience with advanced features like search suggestions, favorites management, and multiple theme support.

## ✨ Key Features

### 🔍 **Advanced Search Engine**
- **Universal Search**: Search both GitHub users and repositories simultaneously
- **Real-time Suggestions**: Intelligent search suggestions based on your search history
- **Smart Filtering**: Advanced filtering and sorting options
- **Instant Results**: Lightning-fast search with smooth animations

### 🎨 **Multiple Theme Support**
- **Light Theme**: Clean and modern light interface
- **Dark Theme**: Easy-on-the-eyes dark mode
- **System Default**: Automatically follows device theme
- **Hacker Theme**: Matrix-inspired green on black
- **Kali Linux Theme**: Dark blue with neon accents
- **Custom Accent Colors**: Personalize your experience

### 💾 **Data Management**
- **Favorites System**: Save your favorite users and repositories
- **Search History**: Quick access to previous searches
- **Offline Cache**: View last searched results without internet
- **Local Storage**: Secure data persistence

### 🚀 **Advanced UI/UX**
- **Material Design 3**: Modern, accessible interface
- **Smooth Animations**: Fluid transitions and micro-interactions
- **Responsive Design**: Optimized for mobile and tablet
- **Pull-to-Refresh**: Intuitive data refresh
- **Hero Animations**: Beautiful detail transitions

## 🛠️ Technical Stack

### **Core Technologies**
- **Flutter**: Cross-platform mobile development
- **Dart**: Programming language
- **Riverpod**: State management
- **Dio**: HTTP client for API calls

### **UI & Animations**
- **Material Design 3**: Modern design system
- **Flutter Animate**: Micro-animations
- **Flutter Staggered Animations**: List animations
- **Lottie**: Advanced animations
- **Flex Color Scheme**: Advanced theming

### **Data & Storage**
- **Hive**: Local database
- **SharedPreferences**: Settings storage
- **JSON Serialization**: Data parsing
- **Cached Network Image**: Image caching

### **GitHub Integration**
- **GitHub REST API**: Official API integration
- **Rate Limit Management**: Smart API usage
- **Token Authentication**: Enhanced API access
- **Error Handling**: Comprehensive error management

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3
  
  # HTTP & API
  dio: ^5.4.0
  http: ^1.1.2
  
  # UI & Animations
  flutter_animate: ^4.5.0
  animations: ^2.0.11
  flutter_staggered_animations: ^1.1.1
  lottie: ^3.1.2
  flex_color_scheme: ^7.3.1
  
  # Navigation
  go_router: ^14.2.0
  
  # Storage
  shared_preferences: ^2.2.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Utilities
  url_launcher: ^6.2.2
  flutter_downloader: ^1.11.5
  path_provider: ^2.1.2
  connectivity_plus: ^5.0.2
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  pull_to_refresh: ^2.0.0
  smooth_page_indicator: ^1.1.0
  intl: ^0.19.0
  
  # JSON
  json_annotation: ^4.8.1
  material_design_icons_flutter: ^7.0.7296

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  
  # Code Generation
  build_runner: ^2.4.7
  riverpod_generator: ^2.3.9
  json_serializable: ^6.7.1
  hive_generator: ^2.0.1
```

## 🚀 Getting Started

### **Prerequisites**
- Flutter SDK (3.16.0 or higher)
- Dart SDK (3.2.0 or higher)
- Android Studio / VS Code
- Git

### **Installation**

1. **Clone the repository**
   ```bash
   git clone https://github.com/JithinGK51/github_fail_project.git
   cd github_fail_project
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### **Android Setup**
- Minimum SDK: 21
- Target SDK: 34
- NDK Version: 27.0.12077973

### **iOS Setup**
- Minimum iOS: 11.0
- Xcode: 14.0+

## 📱 Screenshots

> **Note**: Screenshots will be added as the UI development progresses.

## 🔧 Configuration

### **GitHub API Setup**
1. Create a GitHub Personal Access Token
2. Go to Settings > GitHub API Token
3. Enter your token for enhanced rate limits

### **Theme Customization**
- Navigate to Settings > Theme
- Choose from 5 available themes
- Customize accent colors
- Set system preference

## 🏗️ Project Structure

```
lib/
├── core/                   # Core utilities and configuration
│   ├── app_config.dart
│   ├── app_constants.dart
│   ├── app_icon.dart
│   ├── app_launcher.dart
│   └── error_handler.dart
├── features/              # Feature-based modules
│   ├── home/             # Home screen
│   ├── search/           # Search functionality
│   ├── favorites/        # Favorites management
│   ├── settings/         # Settings and preferences
│   └── splash/           # Splash screen
├── models/               # Data models
│   ├── github_user.dart
│   ├── github_repository.dart
│   └── search_result.dart
├── services/             # Business logic
│   ├── github_api_service.dart
│   ├── search_service.dart
│   ├── storage_service.dart
│   └── search_suggestions_service.dart
├── shared/               # Shared widgets
│   └── widgets/
├── theme/                # Theme configuration
│   ├── app_theme.dart
│   └── theme_provider.dart
└── main.dart             # App entry point
```

## 🚧 Development Status

### **✅ Completed Features**
- [x] Basic app structure and navigation
- [x] GitHub API integration
- [x] Search functionality for users and repositories
- [x] Multiple theme support
- [x] Search suggestions system
- [x] Favorites management
- [x] Settings screen
- [x] Error handling and validation
- [x] Rate limit management
- [x] Android configuration

### **🔄 In Progress**
- [ ] UI/UX polish and animations
- [ ] Advanced search filters
- [ ] Repository details screen
- [ ] User profile screen
- [ ] Download functionality
- [ ] Offline mode improvements

### **📋 Planned Features**
- [ ] GitHub authentication
- [ ] Repository cloning
- [ ] Issue and PR tracking
- [ ] Notifications system
- [ ] Social features
- [ ] Advanced analytics

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### **Development Guidelines**
- Follow Flutter/Dart best practices
- Write comprehensive tests
- Update documentation
- Follow the existing code style
- Test on both Android and iOS

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Jithin G K**
- GitHub: [@JithinGK51](https://github.com/JithinGK51)
- Email: [jithingk831733@gmail.com]

## 🙏 Acknowledgments

- [Flutter Team](https://flutter.dev/) for the amazing framework
- [GitHub](https://github.com/) for the comprehensive API
- [Material Design](https://material.io/) for design guidelines
- [Riverpod](https://riverpod.dev/) for state management
- All open-source contributors

## 📞 Support

If you encounter any issues or have questions:

1. Check the [Issues](https://github.com/JithinGK51/github_fail_project/issues) page
2. Create a new issue with detailed information
3. Contact the maintainer

---

**⭐ Star this repository if you find it helpful!**

*Built with ❤️ using Flutter*
