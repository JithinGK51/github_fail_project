import 'package:json_annotation/json_annotation.dart';

part 'github_user.g.dart';

@JsonSerializable()
class GitHubUser {
  final int id;
  final String login;
  final String? name;
  final String? email;
  final String? bio;
  final String? company;
  final String? blog;
  final String? location;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @JsonKey(name: 'html_url')
  final String? htmlUrl;
  final int? followers;
  final int? following;
  @JsonKey(name: 'public_repos')
  final int? publicRepos;
  @JsonKey(name: 'public_gists')
  final int? publicGists;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  final bool? hireable;
  final String? type;
  @JsonKey(name: 'site_admin')
  final bool? siteAdmin;

  const GitHubUser({
    required this.id,
    required this.login,
    this.name,
    this.email,
    this.bio,
    this.company,
    this.blog,
    this.location,
    this.avatarUrl,
    this.htmlUrl,
    this.followers,
    this.following,
    this.publicRepos,
    this.publicGists,
    this.createdAt,
    this.updatedAt,
    this.hireable,
    this.type,
    this.siteAdmin,
  });

  factory GitHubUser.fromJson(Map<String, dynamic> json) =>
      _$GitHubUserFromJson(json);
  Map<String, dynamic> toJson() => _$GitHubUserToJson(this);

  String get displayName => name ?? login;
  String get profileUrl => htmlUrl ?? 'https://github.com/$login';
}

@JsonSerializable()
class UserSearchResponse {
  @JsonKey(name: 'total_count')
  final int totalCount;
  @JsonKey(name: 'incomplete_results')
  final bool incompleteResults;
  final List<GitHubUser> items;

  const UserSearchResponse({
    required this.totalCount,
    required this.incompleteResults,
    required this.items,
  });

  factory UserSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$UserSearchResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserSearchResponseToJson(this);
}
