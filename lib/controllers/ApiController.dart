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
        // Increased timeouts to 60s for low internet stability
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Accept": "application/json",
        },
      ),
    );

    _initializeInterceptors();
  }

  void _initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final authState = ref.read(authProvider);

          final isAuthApi =
              options.path.contains("send-otp") ||
              options.path.contains("login") ||
              options.path.contains("register") ||
              options.path.contains("verify-otp");

          if (!isAuthApi && authState.accessToken != null) {
            options.headers["Authorization"] =
                "Bearer ${authState.accessToken}";
          }

          return handler.next(options);
        },
        onError: (error, handler) async {
          // Handle Unauthorized
          if (error.response?.statusCode == 401) {
            await ref.read(authProvider.notifier).logout();
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> sendRequest({
    required String path,
    required String method,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      Response response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParams,
        options: Options(method: method.toUpperCase()),
      );

      // Backend usually returns a map, but we check if response.data is null
      return {
        "status": response.data["status"] ?? true,
        "data": response.data,
        "statusCode": response.statusCode,
      };
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        "status": false,
        "message": "An unexpected error occurred",
        "error": e.toString(),
      };
    }
  }

  Map<String, dynamic> _handleDioError(DioException e) {
    String message = "Something went wrong";

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message =
            "Poor internet connection. Please check your signal and try again.";
        break;
      case DioExceptionType.badResponse:
        // Handle cases where the server sends back an error message in the body
        message =
            e.response?.data?["message"] ??
            "Server Error (${e.response?.statusCode})";
        break;
      case DioExceptionType.cancel:
        message = "Request was cancelled";
        break;
      case DioExceptionType.connectionError:
        // This is triggered for socket exceptions, DNS issues, or no physical link
        message =
            "Cannot reach server. Check your internet connection or server status.";
        break;
      case DioExceptionType.unknown:
      default:
        if (e.message != null && e.message!.contains("SocketException")) {
          message = "Network error. Please verify you are online.";
        } else {
          message = "An unknown network error occurred.";
        }
        break;
    }

    return {
      "status": false,
      "message": message,
      "error": e.response?.data ?? e.error?.toString() ?? e.message,
      "statusCode": e.response?.statusCode,
    };
  }
}
