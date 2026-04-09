import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:planit_prep_pro/config/AppConfig.dart' as AppConfig;
import 'package:planit_prep_pro/providers/auth_provider.dart';

class ApiController {
  late Dio _dio;
  final Ref ref;

  ApiController(this.ref) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    );

    _initializeInterceptors();
  }

  //  Interceptors
  void _initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final authState = ref.read(authProvider);

          //  Skip token for auth APIs
          final isAuthApi = options.path.contains("send-otp") || options.path.contains("login") ||
              options.path.contains("register") ||
              options.path.contains("verify-otp");

          if (!isAuthApi && authState.accessToken != null) {
            options.headers["Authorization"] =
                "Bearer ${authState.accessToken}";
          }

          return handler.next(options);
        },

        onError: (error, handler) async {
          //  Handle 401 (token expired / invalid)
          if (error.response?.statusCode == 401) {
            await ref.read(authProvider.notifier).logout();
          }

          return handler.next(error);
        },
      ),
    );
  }

  //  Universal API Call Function
  Future<Map<String, dynamic>> sendRequest({
    required String path,
    required String method, // GET, POST, PUT, DELETE
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      Response response;

      switch (method.toUpperCase()) {
        case "GET":
          response = await _dio.get(
            path,
            queryParameters: queryParams,
          );
          break;

        case "POST":
          response = await _dio.post(
            path,
            data: data,
            queryParameters: queryParams,
          );
          break;

        case "PUT":
          response = await _dio.put(
            path,
            data: data,
            queryParameters: queryParams,
          );
          break;

        case "DELETE":
          response = await _dio.delete(
            path,
            data: data,
            queryParameters: queryParams,
          );
          break;

        default:
          throw Exception("Invalid HTTP method");
      }

      return {
        "status": true,
        "data": response.data,
        "statusCode": response.statusCode,
      };
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        "status": false,
        "message": "Something went wrong",
        "error": e.toString(),
      };
    }
  }

  // Error Handler (Very Important)
  Map<String, dynamic> _handleDioError(DioException e) {
    String message = "Unexpected error occurred";

    if (e.type == DioExceptionType.connectionTimeout) {
      message = "Connection timeout. Please try again.";
    } else if (e.type == DioExceptionType.receiveTimeout) {
      message = "Server took too long to respond.";
    } else if (e.type == DioExceptionType.badResponse) {
      message = e.response?.data["message"] ??
          "Server error (${e.response?.statusCode})";
    } else if (e.type == DioExceptionType.cancel) {
      message = "Request was cancelled";
    } else if (e.type == DioExceptionType.connectionError) {
      message = "No internet connection";
    }

    return {
      "status": false,
      "message": message,
      "error": e.response?.data ?? e.toString(),
      "statusCode": e.response?.statusCode,
    };
  }
}