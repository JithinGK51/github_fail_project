import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../services/search_service.dart';
import '../../models/search_result.dart';
import '../../shared/widgets/search_bar_widget.dart';
import '../../shared/widgets/search_history_widget.dart';
import '../../shared/widgets/search_suggestions_widget.dart';
import '../../shared/widgets/rate_limit_indicator.dart';
import '../../shared/widgets/empty_state_widget.dart';
import '../../shared/widgets/loading_widget.dart';
import '../../shared/widgets/error_widget.dart';
import '../../services/api_test_service.dart';
import 'widgets/user_card.dart';
import 'widgets/repository_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final RefreshController _refreshController = RefreshController();
  late AnimationController _fabController;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Test API connection on init
    ApiTestService.testApiConnection();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _refreshController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.trim().isNotEmpty) {
      setState(() {
        _currentQuery = query;
      });
      ref.read(searchProvider.notifier).search(query);
    }
  }

  void _onSuggestionTap(String suggestion) {
    _searchController.text = suggestion;
    _onSearch(suggestion);
  }

  void _onRefresh() async {
    final currentQuery = ref.read(searchProvider).currentQuery;
    if (currentQuery.isNotEmpty) {
      await ref.read(searchProvider.notifier).search(currentQuery);
    }
    _refreshController.refreshCompleted();
  }

  void _clearSearch() {
    _searchController.clear();
    ref.read(searchProvider.notifier).clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SearchBarWidget(
                controller: _searchController,
                onSearch: _onSearch,
                onChanged: (value) {
                  setState(() {
                    _currentQuery = value;
                  });
                },
                onClear: _clearSearch,
                hintText: 'Search users and repositories...',
              ),
            ),

            // Rate Limit Indicator
            const RateLimitIndicator(),

            // Debug API Test Button (only in debug mode)
            if (kDebugMode)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await ApiTestService.testApiConnection();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'API test completed. Check console for results.',
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.bug_report_rounded),
                  label: const Text('Test API Connection'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),

            // Search Suggestions
            if (_currentQuery.isNotEmpty &&
                !searchState.isLoading &&
                !searchState.hasResults)
              SearchSuggestionsWidget(
                query: _currentQuery,
                onSuggestionTap: _onSuggestionTap,
                onClear: _clearSearch,
              ),

            // Content
            Expanded(child: _buildContent(searchState, theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(SearchState searchState, ThemeData theme) {
    if (searchState.isLoading) {
      return const LoadingWidget();
    }

    if (searchState.hasError) {
      return CustomErrorWidget(
        message: searchState.error!,
        onRetry: () => _onSearch(searchState.currentQuery),
      );
    }

    if (!searchState.hasQuery) {
      return SearchHistoryWidget(
        onSearch: _onSearch,
        onClearHistory:
            () => ref.read(searchProvider.notifier).clearSearchHistory(),
      );
    }

    if (!searchState.hasResults) {
      return EmptyStateWidget(
        icon: Icons.search_off_rounded,
        title: 'No Results Found',
        subtitle: 'Try searching for something else',
        actionText: 'Clear Search',
        onAction: _clearSearch,
      );
    }

    return _buildResults(searchState, theme);
  }

  Widget _buildResults(SearchState searchState, ThemeData theme) {
    final results = searchState.searchResults!;

    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      enablePullDown: true,
      enablePullUp: false,
      header: WaterDropHeader(
        waterDropColor: theme.primaryColor,
        complete: Icon(Icons.check, color: theme.primaryColor),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 100, // Add bottom padding to prevent overflow
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Results Summary
            _buildResultsSummary(results, theme),

            const SizedBox(height: 24),

            // Users Section
            if (results.users.isNotEmpty) ...[
              _buildSectionHeader('Users', results.users.length, theme),
              const SizedBox(height: 16),
              AnimationLimiter(
                child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 375),
                    childAnimationBuilder:
                        (widget) => SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(child: widget),
                        ),
                    children:
                        results.users
                            .map(
                              (user) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: UserCard(
                                  user: user,
                                  onTap: () => _showUserDetails(user),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],

            // Repositories Section
            if (results.repositories.isNotEmpty) ...[
              _buildSectionHeader(
                'Repositories',
                results.repositories.length,
                theme,
              ),
              const SizedBox(height: 16),
              AnimationLimiter(
                child: Column(
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 375),
                    childAnimationBuilder:
                        (widget) => SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(child: widget),
                        ),
                    children:
                        results.repositories
                            .map(
                              (repo) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: RepositoryCard(
                                  repository: repo,
                                  onTap: () => _showRepositoryDetails(repo),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSummary(SearchResult results, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: theme.primaryColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Found ${results.totalResults} results for "${results.query}"',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX();
  }

  Widget _buildSectionHeader(String title, int count, ThemeData theme) {
    return Row(
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _showUserDetails(user) {
    // TODO: Implement user details screen
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('User details: ${user.login}')));
  }

  void _showRepositoryDetails(repository) {
    // TODO: Implement repository details screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Repository details: ${repository.name}')),
    );
  }
}
