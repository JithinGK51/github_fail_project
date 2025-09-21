import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiTestService {
  static const String baseUrl = 'https://api.github.com';

  static Future<void> testApiConnection() async {
    try {
      final dio = Dio();

      // Test basic API connection
      final response = await dio.get(
        '$baseUrl/search/users',
        queryParameters: {'q': 'flutter'},
        options: Options(
          headers: {
            'Accept': 'application/vnd.github.v3+json',
            'User-Agent': 'GitHub-Explore-Flutter-App',
          },
        ),
      );

      if (kDebugMode) {
        print('✅ API Test Results:');
        print('Status Code: ${response.statusCode}');
        print('Response Headers: ${response.headers}');
        print(
          'Rate Limit Remaining: ${response.headers.value('x-ratelimit-remaining')}',
        );
        print(
          'Rate Limit Reset: ${response.headers.value('x-ratelimit-reset')}',
        );
        print('Response Data Keys: ${response.data.keys}');
        print('Total Count: ${response.data['total_count']}');
        print('Items Length: ${response.data['items']?.length ?? 0}');
      }

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('✅ API connection successful!');
        }
      } else {
        if (kDebugMode) {
          print('❌ API returned status: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ API Test Failed: $e');
        if (e is DioException) {
          print('Dio Error Type: ${e.type}');
          print('Dio Error Message: ${e.message}');
          print('Response Status: ${e.response?.statusCode}');
          print('Response Data: ${e.response?.data}');
        }
      }
    }
  }

  static Future<void> testWithToken(String token) async {
    try {
      final dio = Dio();

      final response = await dio.get(
        '$baseUrl/search/repositories',
        queryParameters: {'q': 'flutter'},
        options: Options(
          headers: {
            'Accept': 'application/vnd.github.v3+json',
            'User-Agent': 'GitHub-Explore-Flutter-App',
            'Authorization': 'token $token',
          },
        ),
      );

      if (kDebugMode) {
        print('✅ Token API Test Results:');
        print('Status Code: ${response.statusCode}');
        print(
          'Rate Limit Remaining: ${response.headers.value('x-ratelimit-remaining')}',
        );
        print(
          'Rate Limit Limit: ${response.headers.value('x-ratelimit-limit')}',
        );
        print('Total Count: ${response.data['total_count']}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Token API Test Failed: $e');
      }
    }
  }
}
