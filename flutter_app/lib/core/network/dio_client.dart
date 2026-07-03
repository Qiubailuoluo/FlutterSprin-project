import 'package:dio/dio.dart';
import 'package:ledger/core/constants/api_constants.dart';
import 'package:ledger/core/model/api_result.dart';
import 'package:ledger/core/network/dio_extensions.dart';
import 'package:ledger/core/storage/token_storage.dart';

/// 401 未授权时的回调（清 Token、跳转登录等）。
typedef UnauthorizedCallback = void Function();

/// HTTP 客户端封装：统一基址、超时、Token 注入、401 处理。
///
/// 业务 API 应通过 [get]/[post] 调用；网络与业务错误统一返回 [ApiResult]。
class DioClient {
  DioClient(
    this._tokenStorage, {
    UnauthorizedCallback? onUnauthorized,
  }) : _onUnauthorized = onUnauthorized {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (!_isAuthPath(response.requestOptions.path)) {
            _maybeHandleUnauthorized(response.data);
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (!_isAuthPath(error.requestOptions.path) &&
              error.response?.statusCode == 401) {
            _onUnauthorized?.call();
          }
          handler.next(error);
        },
      ),
    );
  }

  final TokenStorage _tokenStorage;
  final UnauthorizedCallback? _onUnauthorized;
  late final Dio _dio;

  void _maybeHandleUnauthorized(dynamic data) {
    if (data is Map && data['code'] == 401) {
      _onUnauthorized?.call();
    }
  }

  bool _isAuthPath(String path) {
    return path.contains(ApiConstants.loginPath) ||
        path.contains(ApiConstants.registerPath);
  }

  /// GET 请求并解析为 [ApiResult]。
  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T? Function(dynamic json) fromJsonT,
  }) {
    return _dio.getApiResult(
      path,
      queryParameters: queryParameters,
      fromJsonT: fromJsonT,
    );
  }

  /// POST 请求并解析为 [ApiResult]。
  Future<ApiResult<T>> post<T>(
    String path, {
    Object? data,
    required T? Function(dynamic json) fromJsonT,
  }) {
    return _dio.postApiResult(path, data: data, fromJsonT: fromJsonT);
  }

  /// DELETE 请求并解析为 [ApiResult]。
  Future<ApiResult<T>> delete<T>(
    String path, {
    required T? Function(dynamic json) fromJsonT,
  }) {
    return _dio.deleteApiResult(path, fromJsonT: fromJsonT);
  }

  /// PUT 请求并解析为 [ApiResult]。
  Future<ApiResult<T>> put<T>(
    String path, {
    Object? data,
    required T? Function(dynamic json) fromJsonT,
  }) {
    return _dio.putApiResult(path, data: data, fromJsonT: fromJsonT);
  }
}
