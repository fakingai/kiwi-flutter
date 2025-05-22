import 'package:kiwi/core/utils/logger.dart';

// Placeholder for API response structure
class ApiResponse {
  final dynamic data;
  final int? statusCode;
  ApiResponse({this.data, this.statusCode});
}

abstract class ApiClient {
  Future<ApiResponse> get(String path, {Map<String, dynamic>? queryParameters});
  Future<ApiResponse> post(String path, {dynamic data});
  // Add other methods like put, delete, etc.
}

class ApiClientImpl implements ApiClient {
  // final Dio dio;
  final String baseUrl = "{{RAG_API_HOST}}"; // This should come from config

  ApiClientImpl() {
    AppLogger.info(
      'ApiClientImpl: Using mock API client. Base URL placeholder: $baseUrl',
    );
  }

  @override
  Future<ApiResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    AppLogger.debug('ApiClient: GET $path, params: $queryParameters');
    // Mock response for /api/projects
    if (path == '/api/projects') {
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay
      return ApiResponse(
        statusCode: 200,
        data: [
          {
            'id': '1',
            'name': 'Project Alpha',
            'created_at':
                DateTime.now()
                    .subtract(const Duration(days: 1))
                    .toIso8601String(),
            'updated_at':
                DateTime.now()
                    .subtract(const Duration(hours: 5))
                    .toIso8601String(),
          },
          {
            'id': '2',
            'name': 'Project Beta',
            'created_at':
                DateTime.now()
                    .subtract(const Duration(days: 3))
                    .toIso8601String(),
            'updated_at':
                DateTime.now()
                    .subtract(const Duration(days: 2))
                    .toIso8601String(),
          },
          {
            'id': '3',
            'name': 'Project Gamma',
            'created_at':
                DateTime.now()
                    .subtract(const Duration(days: 5))
                    .toIso8601String(),
            'updated_at':
                DateTime.now()
                    .subtract(const Duration(days: 4))
                    .toIso8601String(),
          },
          {
            'id': '4',
            'name': 'Project Delta',
            'created_at':
                DateTime.now()
                    .subtract(const Duration(days: 2))
                    .toIso8601String(),
            'updated_at':
                DateTime.now()
                    .subtract(const Duration(hours: 10))
                    .toIso8601String(),
          },
          {
            'id': '5',
            'name': 'Project Epsilon',
            'created_at':
                DateTime.now()
                    .subtract(const Duration(days: 10))
                    .toIso8601String(),
            'updated_at':
                DateTime.now()
                    .subtract(const Duration(days: 1))
                    .toIso8601String(),
          },
          {
            'id': '6',
            'name': 'Project Zeta',
            'created_at':
                DateTime.now()
                    .subtract(const Duration(days: 7))
                    .toIso8601String(),
            'updated_at':
                DateTime.now()
                    .subtract(const Duration(days: 6))
                    .toIso8601String(),
          },
        ],
      );
    }
    return ApiResponse(statusCode: 404, data: {'message': 'Not Found'});
  }

  @override
  Future<ApiResponse> post(String path, {dynamic data}) async {
    AppLogger.debug('ApiClient: POST $path, data: $data');
    await Future.delayed(const Duration(seconds: 1));
    return ApiResponse(statusCode: 201, data: {'message': 'Created'});
  }
}
