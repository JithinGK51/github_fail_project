import 'package:json_annotation/json_annotation.dart';
import 'github_user.dart';
import 'github_repository.dart';

part 'search_result.g.dart';

@JsonSerializable()
class SearchResult {
  final String query;
  final List<GitHubUser> users;
  final List<GitHubRepository> repositories;
  final DateTime timestamp;
  final int totalUsers;
  final int totalRepositories;

  const SearchResult({
    required this.query,
    required this.users,
    required this.repositories,
    required this.timestamp,
    required this.totalUsers,
    required this.totalRepositories,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);
  Map<String, dynamic> toJson() => _$SearchResultToJson(this);

  bool get hasResults => users.isNotEmpty || repositories.isNotEmpty;
  int get totalResults => totalUsers + totalRepositories;
}

@JsonSerializable()
class SearchHistoryItem {
  final String query;
  final DateTime timestamp;
  final int resultCount;

  const SearchHistoryItem({
    required this.query,
    required this.timestamp,
    required this.resultCount,
  });

  factory SearchHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryItemFromJson(json);
  Map<String, dynamic> toJson() => _$SearchHistoryItemToJson(this);
}

@JsonSerializable()
class FavoriteItem {
  final String id;
  final String type; // 'user' or 'repository'
  final Map<String, dynamic> data;
  final DateTime addedAt;

  const FavoriteItem({
    required this.id,
    required this.type,
    required this.data,
    required this.addedAt,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) =>
      _$FavoriteItemFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteItemToJson(this);

  bool get isUser => type == 'user';
  bool get isRepository => type == 'repository';
}
