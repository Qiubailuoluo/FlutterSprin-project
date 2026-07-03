/// 与后端 Result 结构对应的统一响应模型。
///
/// 成功：code == 200，数据在 [data]；
/// 失败：code != 200，提示信息在 [message]。
class ApiResult<T> {
  final int code;
  final String message;
  final T? data;

  const ApiResult({
    required this.code,
    required this.message,
    this.data,
  });

  bool get isSuccess => code == 200;

  factory ApiResult.fromJson(
    Map<String, dynamic> json,
    T? Function(dynamic json) fromJsonT,
  ) {
    return ApiResult(
      code: json['code'] as int? ?? 500,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
