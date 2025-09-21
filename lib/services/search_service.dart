import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../models/search_result.dart';
import 'github_api_service.dart';
import 'storage_service.dart';

class SearchNotifier extends StateNotifier<SearchState> {
  final GitHubApiService _apiService;
  final StorageService _storageService;

  SearchNotifier(this._apiService, this._storageService)
    : super(const SearchState()) {
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final history = await _storageService.getSearchHistory();
    state = state.copyWith(searchHistory: history);
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(
        currentQuery: '',
        searchResults: null,
        isLoading: false,
        error: null,
      );
      return;
    }

    // Validate query length
    if (query.trim().length < 2) {
      state = state.copyWith(
        currentQuery: query,
        searchResults: null,
        isLoading: false,
        error: 'Search query must be at least 2 characters long',
      );
      return;
    }

    // Check for rate limiting
    if (_apiService.isRateLimited) {
      state = state.copyWith(
        currentQuery: query,
        searchResults: null,
        isLoading: false,
        error: 'Rate limit exceeded. Please try again later.',
      );
      return;
    }

    state = state.copyWith(currentQuery: query, isLoading: true, error: null);

    try {
      if (kDebugMode) {
        print('🔍 SearchService: Starting search for: $query');
      }

      final results = await _apiService.searchAll(query);

      if (kDebugMode) {
        print('✅ SearchService: Search completed successfully');
        print('Users found: ${results.users.length}');
        print('Repositories found: ${results.repositories.length}');
        print('Total results: ${results.totalResults}');
      }

      // Save to search history
      await _storageService.addToSearchHistory(
        SearchHistoryItem(
          query: query,
          timestamp: DateTime.now(),
          resultCount: results.totalResults,
        ),
      );

      // Update search history in state
      final updatedHistory = await _storageService.getSearchHistory();

      state = state.copyWith(
        searchResults: results,
        isLoading: false,
        searchHistory: updatedHistory,
      );
    } catch (e) {
      if (kDebugMode) {
        print('❌ SearchService: Search failed: $e');
      }
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearSearch() {
    state = state.copyWith(currentQuery: '', searchResults: null, error: null);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<void> clearSearchHistory() async {
    await _storageService.clearSearchHistory();
    state = state.copyWith(searchHistory: []);
  }

  void removeFromHistory(String query) async {
    await _storageService.removeFromSearchHistory(query);
    final updatedHistory = await _storageService.getSearchHistory();
    state = state.copyWith(searchHistory: updatedHistory);
  }
}

class SearchState {
  final String currentQuery;
  final SearchResult? searchResults;
  final bool isLoading;
  final String? error;
  final List<SearchHistoryItem> searchHistory;

  const SearchState({
    this.currentQuery = '',
    this.searchResults,
    this.isLoading = false,
    this.error,
    this.searchHistory = const [],
  });

  SearchState copyWith({
    String? currentQuery,
    SearchResult? searchResults,
    bool? isLoading,
    String? error,
    List<SearchHistoryItem>? searchHistory,
  }) {
    return SearchState(
      currentQuery: currentQuery ?? this.currentQuery,
      searchResults: searchResults ?? this.searchResults,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      searchHistory: searchHistory ?? this.searchHistory,
    );
  }

  bool get hasResults => searchResults?.hasResults ?? false;
  bool get hasError => error != null;
  bool get hasQuery => currentQuery.isNotEmpty;
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((
  ref,
) {
  final apiService = ref.watch(githubApiServiceProvider);
  final storageService = ref.watch(storageServiceProvider);
  return SearchNotifier(apiService, storageService);
});
