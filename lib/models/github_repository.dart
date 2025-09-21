import 'package:json_annotation/json_annotation.dart';
import 'github_user.dart';

part 'github_repository.g.dart';

@JsonSerializable()
class GitHubRepository {
  final int id;
  final String name;
  @JsonKey(name: 'full_name')
  final String fullName;
  final String? description;
  final String? homepage;
  final String? language;
  @JsonKey(name: 'stargazers_count')
  final int? stargazersCount;
  @JsonKey(name: 'watchers_count')
  final int? watchersCount;
  @JsonKey(name: 'forks_count')
  final int? forksCount;
  @JsonKey(name: 'open_issues_count')
  final int? openIssuesCount;
  final String? license;
  final bool fork;
  final bool archived;
  final bool disabled;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'pushed_at')
  final String? pushedAt;
  @JsonKey(name: 'clone_url')
  final String? cloneUrl;
  @JsonKey(name: 'html_url')
  final String? htmlUrl;
  @JsonKey(name: 'svn_url')
  final String? svnUrl;
  @JsonKey(name: 'git_url')
  final String? gitUrl;
  @JsonKey(name: 'ssh_url')
  final String? sshUrl;
  final int? size;
  @JsonKey(name: 'default_branch')
  final String? defaultBranch;
  @JsonKey(fromJson: _ownerFromJson, toJson: _ownerToJson)
  final GitHubUser? owner;
  final List<String>? topics;
  final int? forks;
  @JsonKey(name: 'open_issues')
  final int? openIssues;
  final int? watchers;
  @JsonKey(name: 'has_issues')
  final bool? hasIssues;
  @JsonKey(name: 'has_projects')
  final bool? hasProjects;
  @JsonKey(name: 'has_downloads')
  final bool? hasDownloads;
  @JsonKey(name: 'has_wiki')
  final bool? hasWiki;
  @JsonKey(name: 'has_pages')
  final bool? hasPages;
  @JsonKey(name: 'language_color')
  final String? languageColor;

  const GitHubRepository({
    required this.id,
    required this.name,
    required this.fullName,
    this.description,
    this.homepage,
    this.language,
    this.stargazersCount,
    this.watchersCount,
    this.forksCount,
    this.openIssuesCount,
    this.license,
    required this.fork,
    required this.archived,
    required this.disabled,
    this.createdAt,
    this.updatedAt,
    this.pushedAt,
    this.cloneUrl,
    this.htmlUrl,
    this.svnUrl,
    this.gitUrl,
    this.sshUrl,
    this.size,
    this.defaultBranch,
    this.owner,
    this.topics,
    this.forks,
    this.openIssues,
    this.watchers,
    this.hasIssues,
    this.hasProjects,
    this.hasDownloads,
    this.hasWiki,
    this.hasPages,
    this.languageColor,
  });

  factory GitHubRepository.fromJson(Map<String, dynamic> json) =>
      _$GitHubRepositoryFromJson(json);
  Map<String, dynamic> toJson() => _$GitHubRepositoryToJson(this);

  static GitHubUser? _ownerFromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return GitHubUser.fromJson(json);
  }

  static Map<String, dynamic>? _ownerToJson(GitHubUser? owner) {
    return owner?.toJson();
  }

  String get repoUrl => htmlUrl ?? 'https://github.com/$fullName';
  String get displayDescription => description ?? 'No description available';
  String get displayLanguage => language ?? 'Unknown';
  String get displayLicense => license ?? 'No license';

  String get formattedSize {
    if (size < 1024) return '${size} B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024)
      return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

@JsonSerializable()
class RepositorySearchResponse {
  @JsonKey(name: 'total_count')
  final int totalCount;
  @JsonKey(name: 'incomplete_results')
  final bool incompleteResults;
  final List<GitHubRepository> items;

  const RepositorySearchResponse({
    required this.totalCount,
    required this.incompleteResults,
    required this.items,
  });

  factory RepositorySearchResponse.fromJson(Map<String, dynamic> json) =>
      _$RepositorySearchResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RepositorySearchResponseToJson(this);
}

@JsonSerializable()
class GitHubLicense {
  final String key;
  final String name;
  final String? spdxId;
  final String? url;
  final String? nodeId;

  const GitHubLicense({
    required this.key,
    required this.name,
    this.spdxId,
    this.url,
    this.nodeId,
  });

  factory GitHubLicense.fromJson(Map<String, dynamic> json) =>
      _$GitHubLicenseFromJson(json);
  Map<String, dynamic> toJson() => _$GitHubLicenseToJson(this);
}
