# Contributing to GitHub Explore

Thank you for your interest in contributing to GitHub Explore! This document provides guidelines and information for contributors.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.16.0 or higher)
- Dart SDK (3.2.0 or higher)
- Git
- Android Studio or VS Code with Flutter extensions

### Development Setup

1. **Fork and Clone**
   ```bash
   git clone https://github.com/YOUR_USERNAME/github_fail_project.git
   cd github_fail_project
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run Tests**
   ```bash
   flutter test
   ```

## 📋 Development Guidelines

### Code Style
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

### Commit Messages
Use conventional commit format:
```
type(scope): description

feat(search): add advanced filtering options
fix(api): resolve rate limit handling
docs(readme): update installation instructions
```

### Pull Request Process

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Changes**
   - Write clean, tested code
   - Update documentation if needed
   - Add tests for new features

3. **Test Your Changes**
   ```bash
   flutter test
   flutter analyze
   flutter run --debug
   ```

4. **Commit and Push**
   ```bash
   git add .
   git commit -m "feat: add your feature"
   git push origin feature/your-feature-name
   ```

5. **Create Pull Request**
   - Provide clear description
   - Link related issues
   - Add screenshots if UI changes

## 🏗️ Architecture

### Project Structure
```
lib/
├── core/           # Core utilities
├── features/       # Feature modules
├── models/         # Data models
├── services/       # Business logic
├── shared/         # Shared components
└── theme/          # Theme configuration
```

### State Management
- Use Riverpod for state management
- Keep state as close to where it's used as possible
- Use providers for dependency injection

### API Integration
- All API calls go through `GitHubApiService`
- Handle errors gracefully
- Implement proper rate limiting

## 🧪 Testing

### Unit Tests
- Test business logic in services
- Test model serialization/deserialization
- Test utility functions

### Widget Tests
- Test UI components
- Test user interactions
- Test different states

### Integration Tests
- Test complete user flows
- Test API integration
- Test theme switching

## 🐛 Bug Reports

When reporting bugs, please include:
- Flutter version
- Device/OS information
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable

## 💡 Feature Requests

When suggesting features:
- Check existing issues first
- Provide clear use case
- Consider implementation complexity
- Think about user experience

## 📝 Documentation

- Update README for major changes
- Document new APIs
- Add code comments for complex logic
- Update this file if needed

## 🤝 Code Review

### For Reviewers
- Check code quality and style
- Verify tests are included
- Test the changes locally
- Provide constructive feedback

### For Authors
- Respond to feedback promptly
- Make requested changes
- Ask questions if unclear
- Thank reviewers

## 📞 Getting Help

- Check existing issues
- Join discussions
- Contact maintainers
- Read Flutter documentation

## 🎯 Current Priorities

1. **UI/UX Polish**: Improve animations and transitions
2. **Performance**: Optimize search and rendering
3. **Features**: Add repository details screen
4. **Testing**: Increase test coverage
5. **Documentation**: Improve code documentation

## 📋 Issue Labels

- `bug`: Something isn't working
- `enhancement`: New feature or request
- `documentation`: Improvements to documentation
- `good first issue`: Good for newcomers
- `help wanted`: Extra attention needed
- `priority: high`: High priority
- `priority: low`: Low priority

## 🏆 Recognition

Contributors will be recognized in:
- README contributors section
- Release notes
- Project documentation

Thank you for contributing to GitHub Explore! 🎉
