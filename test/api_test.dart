import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';

void main() {
  group('GitHub API Tests', () {
    late Dio dio;

    setUp(() {
      dio = Dio();
    });

    test('Test GitHub API Users Endpoint', () async {
      try {
        final response = await dio.get(
          'https://api.github.com/search/users',
          queryParameters: {'q': 'flutter'},
          options: Options(
            headers: {
              'Accept': 'application/vnd.github.v3+json',
              'User-Agent': 'GitHub-Explore-Flutter-App',
            },
          ),
        );

        expect(response.statusCode, 200);
        expect(response.data, isA<Map<String, dynamic>>());
        expect(response.data['total_count'], isA<int>());
        expect(response.data['items'], isA<List>());

        print('✅ Users API Test Passed');
        print('Status: ${response.statusCode}');
        print('Total Count: ${response.data['total_count']}');
        print('Items: ${response.data['items'].length}');
      } catch (e) {
        fail('Users API test failed: $e');
      }
    });

    test('Test GitHub API Repositories Endpoint', () async {
      try {
        final response = await dio.get(
          'https://api.github.com/search/repositories',
          queryParameters: {'q': 'flutter'},
          options: Options(
            headers: {
              'Accept': 'application/vnd.github.v3+json',
              'User-Agent': 'GitHub-Explore-Flutter-App',
            },
          ),
        );

        expect(response.statusCode, 200);
        expect(response.data, isA<Map<String, dynamic>>());
        expect(response.data['total_count'], isA<int>());
        expect(response.data['items'], isA<List>());

        print('✅ Repositories API Test Passed');
        print('Status: ${response.statusCode}');
        print('Total Count: ${response.data['total_count']}');
        print('Items: ${response.data['items'].length}');
      } catch (e) {
        fail('Repositories API test failed: $e');
      }
    });

    test('Test Rate Limit Headers', () async {
      try {
        final response = await dio.get(
          'https://api.github.com/search/users',
          queryParameters: {'q': 'test'},
          options: Options(
            headers: {
              'Accept': 'application/vnd.github.v3+json',
              'User-Agent': 'GitHub-Explore-Flutter-App',
            },
          ),
        );

        expect(response.statusCode, 200);
        expect(response.headers.value('x-ratelimit-remaining'), isNotNull);
        expect(response.headers.value('x-ratelimit-limit'), isNotNull);

        print('✅ Rate Limit Headers Test Passed');
        print('Remaining: ${response.headers.value('x-ratelimit-remaining')}');
        print('Limit: ${response.headers.value('x-ratelimit-limit')}');
      } catch (e) {
        fail('Rate limit headers test failed: $e');
      }
    });
  });
}
