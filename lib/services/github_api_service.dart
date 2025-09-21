import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import '../models/github_user.dart';
import '../models/github_repository.dart';
import '../models/search_result.dart';

class GitHubApiService {
  static const String baseUrl = 'https://api.github.com';
  static const int rateLimit = 60; // requests per hour for unauthenticated
  static const int authenticatedRateLimit =
      5000; // requests per hour for authenticated

  late final Dio _dio;
  String? _token;
  int _remainingRequests = rateLimit;
  DateTime? _rateLimitResetTime;

  int get remainingRequests => _remainingRequests;

  GitHubApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'Accept': 'application/vnd.github.v3+json',
          'User-Agent': 'GitHub-Explore-Flutter-App',
        },
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers['Authorization'] = 'token $_token';
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          _updateRateLimit(response);
          handler.next(response);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 403) {
            _handleRateLimitError(error.response);
          }
          handler.next(error);
        },
      ),
    );
  }

  void setToken(String? token) {
    _token = token;
  }

  void _updateRateLimit(Response response) {
    final remaining = response.headers.value('x-ratelimit-remaining');
    final resetTime = response.headers.value('x-ratelimit-reset');

    if (remaining != null) {
      _remainingRequests = int.parse(remaining);
    }

    if (resetTime != null) {
      _rateLimitResetTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(resetTime) * 1000,
      );
    }
  }

  void _handleRateLimitError(Response? response) {
    if (response?.statusCode == 403) {
      final resetTime = response?.headers.value('x-ratelimit-reset');
      if (resetTime != null) {
        _rateLimitResetTime = DateTime.fromMillisecondsSinceEpoch(
          int.parse(resetTime) * 1000,
        );
      }
    }
  }

  bool get isRateLimited {
    if (_remainingRequests <= 0) {
      if (_rateLimitResetTime != null) {
        return DateTime.now().isBefore(_rateLimitResetTime!);
      }
      return true;
    }
    return false;
  }

  Duration? get timeUntilRateLimitReset {
    if (_rateLimitResetTime != null) {
      final now = DateTime.now();
      if (_rateLimitResetTime!.isAfter(now)) {
        return _rateLimitResetTime!.difference(now);
      }
    }
    return null;
  }

  Future<SearchResult> searchAll(String query) async {
    if (query.trim().isEmpty) {
      throw Exception('Search query cannot be empty');
    }

    if (isRateLimited) {
      throw Exception('Rate limit exceeded. Please try again later.');
    }

    try {
      final futures = await Future.wait([
        searchUsers(query),
        searchRepositories(query),
      ]);

      final userResponse = futures[0] as UserSearchResponse;
      final repoResponse = futures[1] as RepositorySearchResponse;

      return SearchResult(
        query: query,
        users: userResponse.items,
        repositories: repoResponse.items,
        timestamp: DateTime.now(),
        totalUsers: userResponse.totalCount,
        totalRepositories: repoResponse.totalCount,
      );
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw Exception('No internet connection. Please check your network.');
      } else if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timed out. Please try again.');
      } else if (e.toString().contains('FormatException')) {
        throw Exception('Invalid response format. Please try again.');
      } else {
        throw Exception('Failed to search: ${e.toString()}');
      }
    }
  }

  Future<UserSearchResponse> searchUsers(String query) async {
    try {
      if (kDebugMode) {
        print('🔍 Searching users for: $query');
      }

      final response = await _dio.get(
        '/search/users',
        queryParameters: {
          'q': query,
          'per_page': 30,
          'sort': 'followers',
          'order': 'desc',
        },
      );

      if (kDebugMode) {
        print('✅ Users API Response:');
        print('Status: ${response.statusCode}');
        print(
          'Rate Limit Remaining: ${response.headers.value('x-ratelimit-remaining')}',
        );
        print('Total Count: ${response.data['total_count']}');
        print('Items Count: ${response.data['items']?.length ?? 0}');
      }

      return UserSearchResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Users API Error:');
        print('Status: ${e.response?.statusCode}');
        print('Message: ${e.message}');
        print('Response: ${e.response?.data}');
      }

      if (e.response?.statusCode == 403) {
        throw Exception('Rate limit exceeded. Please try again later.');
      } else if (e.response?.statusCode == 422) {
        throw Exception(
          'Invalid search query. Please try a different search term.',
        );
      }

      throw Exception('Failed to search users: ${e.message}');
    } catch (e) {
      if (kDebugMode) {
        print('❌ Users Search Error: $e');
      }
      throw Exception('Failed to search users: ${e.toString()}');
    }
  }

  Future<RepositorySearchResponse> searchRepositories(String query) async {
    try {
      if (kDebugMode) {
        print('🔍 Searching repositories for: $query');
      }

      final response = await _dio.get(
        '/search/repositories',
        queryParameters: {
          'q': query,
          'per_page': 30,
          'sort': 'stars',
          'order': 'desc',
        },
      );

      if (kDebugMode) {
        print('✅ Repositories API Response:');
        print('Status: ${response.statusCode}');
        print(
          'Rate Limit Remaining: ${response.headers.value('x-ratelimit-remaining')}',
        );
        print('Total Count: ${response.data['total_count']}');
        print('Items Count: ${response.data['items']?.length ?? 0}');
      }

      return RepositorySearchResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Repositories API Error:');
        print('Status: ${e.response?.statusCode}');
        print('Message: ${e.message}');
        print('Response: ${e.response?.data}');
      }

      if (e.response?.statusCode == 403) {
        throw Exception('Rate limit exceeded. Please try again later.');
      } else if (e.response?.statusCode == 422) {
        throw Exception(
          'Invalid search query. Please try a different search term.',
        );
      }

      throw Exception('Failed to search repositories: ${e.message}');
    } catch (e) {
      if (kDebugMode) {
        print('❌ Repositories Search Error: $e');
      }
      throw Exception('Failed to search repositories: ${e.toString()}');
    }
  }

  Future<GitHubUser> getUser(String username) async {
    try {
      final response = await _dio.get('/users/$username');
      return GitHubUser.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get user: ${e.toString()}');
    }
  }

  Future<GitHubRepository> getRepository(String owner, String repo) async {
    try {
      final response = await _dio.get('/repos/$owner/$repo');
      return GitHubRepository.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get repository: ${e.toString()}');
    }
  }

  Future<List<GitHubRepository>> getUserRepositories(String username) async {
    try {
      final response = await _dio.get(
        '/users/$username/repos',
        queryParameters: {'per_page': 100, 'sort': 'updated', 'order': 'desc'},
      );

      return (response.data as List)
          .map((json) => GitHubRepository.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user repositories: ${e.toString()}');
    }
  }

  Future<List<GitHubRepository>> getStarredRepositories(String username) async {
    try {
      final response = await _dio.get(
        '/users/$username/starred',
        queryParameters: {'per_page': 100, 'sort': 'updated', 'order': 'desc'},
      );

      return (response.data as List)
          .map((json) => GitHubRepository.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get starred repositories: ${e.toString()}');
    }
  }
}

final githubApiServiceProvider = Provider<GitHubApiService>((ref) {
  return GitHubApiService();
});
