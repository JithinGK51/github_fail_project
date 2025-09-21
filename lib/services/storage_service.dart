import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/search_result.dart';
import '../models/github_user.dart';
import '../models/github_repository.dart';

class StorageService {
  static const String _searchHistoryKey = 'search_history';
  static const String _tokenKey = 'github_token';
  static const int _maxHistoryItems = 50;
  static const int _maxCacheItems = 20;

  late Box _favoritesBox;
  late Box _cacheBox;

  Future<void> init() async {
    await Hive.initFlutter();

    _favoritesBox = await Hive.openBox<FavoriteItem>('favorites');
    _cacheBox = await Hive.openBox<SearchResult>('cache');
  }

  // Search History
  Future<List<SearchHistoryItem>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_searchHistoryKey) ?? [];

    return historyJson
        .map((json) => SearchHistoryItem.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> addToSearchHistory(SearchHistoryItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getSearchHistory();

    // Remove existing entry with same query
    history.removeWhere((h) => h.query == item.query);

    // Add new item at the beginning
    history.insert(0, item);

    // Keep only the most recent items
    if (history.length > _maxHistoryItems) {
      history.removeRange(_maxHistoryItems, history.length);
    }

    final historyJson =
        history.map((item) => jsonEncode(item.toJson())).toList();

    await prefs.setStringList(_searchHistoryKey, historyJson);
  }

  Future<void> removeFromSearchHistory(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getSearchHistory();

    history.removeWhere((h) => h.query == query);

    final historyJson =
        history.map((item) => jsonEncode(item.toJson())).toList();

    await prefs.setStringList(_searchHistoryKey, historyJson);
  }

  Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_searchHistoryKey);
  }

  // Favorites
  Future<List<FavoriteItem>> getFavorites() async {
    return _favoritesBox.values.cast<FavoriteItem>().toList();
  }

  Future<void> addToFavorites(FavoriteItem item) async {
    await _favoritesBox.put(item.id, item);
  }

  Future<void> removeFromFavorites(String id) async {
    await _favoritesBox.delete(id);
  }

  Future<bool> isFavorite(String id) async {
    return _favoritesBox.containsKey(id);
  }

  Future<void> clearFavorites() async {
    await _favoritesBox.clear();
  }

  // Cache
  Future<SearchResult?> getCachedResult(String query) async {
    return _cacheBox.get(query);
  }

  Future<void> cacheResult(String query, SearchResult result) async {
    // Remove oldest cache entries if we exceed the limit
    if (_cacheBox.length >= _maxCacheItems) {
      final keys = _cacheBox.keys.toList();
      keys.sort(); // Sort by insertion order
      for (int i = 0; i < keys.length - _maxCacheItems + 1; i++) {
        await _cacheBox.delete(keys[i]);
      }
    }

    await _cacheBox.put(query, result);
  }

  Future<void> clearCache() async {
    await _cacheBox.clear();
  }

  // GitHub Token
  Future<String?> getGitHubToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> setGitHubToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString(_tokenKey, token);
    } else {
      await prefs.remove(_tokenKey);
    }
  }

  // Helper methods for favorites
  Future<void> addUserToFavorites(GitHubUser user) async {
    final item = FavoriteItem(
      id: 'user_${user.id}',
      type: 'user',
      data: user.toJson(),
      addedAt: DateTime.now(),
    );
    await addToFavorites(item);
  }

  Future<void> addRepositoryToFavorites(GitHubRepository repository) async {
    final item = FavoriteItem(
      id: 'repo_${repository.id}',
      type: 'repository',
      data: repository.toJson(),
      addedAt: DateTime.now(),
    );
    await addToFavorites(item);
  }

  Future<void> removeUserFromFavorites(int userId) async {
    await removeFromFavorites('user_$userId');
  }

  Future<void> removeRepositoryFromFavorites(int repoId) async {
    await removeFromFavorites('repo_$repoId');
  }

  Future<bool> isUserFavorite(int userId) async {
    return await isFavorite('user_$userId');
  }

  Future<bool> isRepositoryFavorite(int repoId) async {
    return await isFavorite('repo_$repoId');
  }

  Future<List<GitHubUser>> getFavoriteUsers() async {
    final favorites = await getFavorites();
    return favorites
        .where((item) => item.isUser)
        .map((item) => GitHubUser.fromJson(item.data))
        .toList();
  }

  Future<List<GitHubRepository>> getFavoriteRepositories() async {
    final favorites = await getFavorites();
    return favorites
        .where((item) => item.isRepository)
        .map((item) => GitHubRepository.fromJson(item.data))
        .toList();
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});
