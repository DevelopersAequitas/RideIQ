import 'package:dio/dio.dart'; 
 
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rideiq/core/constants/api_constants.dart';
import 'package:rideiq/core/utils/app_logger.dart';
import 'package:rideiq/core/services/local_service.dart';

import 'package:firebase_auth/firebase_auth.dart';


part 'api_service.g.dart';

@riverpod
ApiService apiService(Ref ref) {
  return ApiService();
}

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 1. Skip backend token for the verification endpoint itself
        if (options.path.contains(ApiConstants.verifyAuth)) {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            final token = await user.getIdToken();
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        }

        // 2. Try to use stored backend token (Bearer token)
        final backendToken = await LocalService.getAuthToken();
        if (backendToken != null && backendToken.isNotEmpty) {
          AppLogger.info('Using Backend Bearer token for: ${options.path}', tag: 'ApiService');
          options.headers['Authorization'] = 'Bearer $backendToken';
          return handler.next(options);
        }

        // 3. Fallback to fresh Firebase token if no backend token exists yet
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final token = await user.getIdToken(options.path.contains('/truv/'));
          AppLogger.info('No backend token. Falling back to Firebase token for: ${options.path}', tag: 'ApiService');
          options.headers['Authorization'] = 'Bearer $token';
        }

        return handler.next(options);
      },


      onError: (DioException e, handler) async {
        // Simple error logging with the new colored AppLogger
        AppLogger.error('API Error: ${e.requestOptions.path}', error: e.response?.data ?? e.message, tag: 'ApiService');
        return handler.next(e);
      },

    ));


    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  // GET
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PATCH
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      return e.response?.data['message'] ?? 'Something went wrong';
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      default:
        return 'Unexpected error occurred';
    }
  }
}
