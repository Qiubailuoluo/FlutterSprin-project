import 'package:dio/dio.dart';
import 'package:ledger/core/model/api_result.dart';

/// Dio 网络层扩展：将后端 Result JSON 与网络异常统一转为 [ApiResult]。
extension DioClientRequest on Dio {
  /// 执行 GET 并解析为 ApiResult，HTTP/业务错误均不抛异常。
  Future<ApiResult<T>> getApiResult<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T? Function(dynamic json) fromJsonT,
  }) async {
    try {
      final response = await get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );
      return ApiResult.fromJson(response.data ?? {}, fromJsonT);
    } on DioException catch (e) {
      return _fromDioError(e, fromJsonT);
    }
  }

  /// 执行 POST 并解析为 ApiResult。
  Future<ApiResult<T>> postApiResult<T>(
    String path, {
    Object? data,
    required T? Function(dynamic json) fromJsonT,
  }) async {
    try {
      final response = await post<Map<String, dynamic>>(path, data: data);
      return ApiResult.fromJson(response.data ?? {}, fromJsonT);
    } on DioException catch (e) {
      return _fromDioError(e, fromJsonT);
    }
  }

  /// 执行 DELETE 并解析为 ApiResult。
  Future<ApiResult<T>> deleteApiResult<T>(
    String path, {
    required T? Function(dynamic json) fromJsonT,
  }) async {
    try {
      final response = await delete<Map<String, dynamic>>(path);
      return ApiResult.fromJson(response.data ?? {}, fromJsonT);
    } on DioException catch (e) {
      return _fromDioError(e, fromJsonT);
    }
  }

  /// 执行 PUT 并解析为 ApiResult。
  Future<ApiResult<T>> putApiResult<T>(
    String path, {
    Object? data,
    required T? Function(dynamic json) fromJsonT,
  }) async {
    try {
      final response = await put<Map<String, dynamic>>(path, data: data);
      return ApiResult.fromJson(response.data ?? {}, fromJsonT);
    } on DioException catch (e) {
      return _fromDioError(e, fromJsonT);
    }
  }

  ApiResult<T> _fromDioError<T>(
    DioException e,
    T? Function(dynamic json) fromJsonT,
  ) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      return ApiResult.fromJson(data, fromJsonT);
    }
    return ApiResult(
      code: 500,
      message: e.message ?? '网络连接失败',
    );
  }
}
