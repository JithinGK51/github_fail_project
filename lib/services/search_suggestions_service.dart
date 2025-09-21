import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SearchSuggestionsService {
  static const String _suggestionsKey = 'search_suggestions';
  static const int _maxSuggestions = 10;

  Future<List<String>> getSuggestions(String query) async {
    if (query.trim().isEmpty) return [];

    final prefs = await SharedPreferences.getInstance();
    final suggestionsJson = prefs.getStringList(_suggestionsKey) ?? [];
    final suggestions =
        suggestionsJson.map((s) => jsonDecode(s) as String).toList();

    // Filter suggestions that start with the query
    final filteredSuggestions =
        suggestions
            .where(
              (suggestion) =>
                  suggestion.toLowerCase().startsWith(query.toLowerCase()),
            )
            .take(_maxSuggestions)
            .toList();

    return filteredSuggestions;
  }

  Future<void> addSuggestion(String suggestion) async {
    if (suggestion.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final suggestionsJson = prefs.getStringList(_suggestionsKey) ?? [];
    final suggestions =
        suggestionsJson.map((s) => jsonDecode(s) as String).toList();

    // Remove if already exists
    suggestions.remove(suggestion);

    // Add to beginning
    suggestions.insert(0, suggestion);

    // Keep only max suggestions
    if (suggestions.length > _maxSuggestions) {
      suggestions.removeRange(_maxSuggestions, suggestions.length);
    }

    // Save back
    final updatedSuggestions = suggestions.map((s) => jsonEncode(s)).toList();
    await prefs.setStringList(_suggestionsKey, updatedSuggestions);
  }

  Future<void> clearSuggestions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_suggestionsKey);
  }
}

final searchSuggestionsServiceProvider = Provider<SearchSuggestionsService>((
  ref,
) {
  return SearchSuggestionsService();
});
