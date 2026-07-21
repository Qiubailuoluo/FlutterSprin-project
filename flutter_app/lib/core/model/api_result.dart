/// 与后端 Result 结构对应的统一响应模型。
///
/// 成功：code == 200，数据在 [data]；
/// 失败：code != 200，提示信息在 [message]；
/// 未知异常：可能带 [errorId]，用于反馈排查（见 docs/api/auth.md）。
class ApiResult<T> {
  final int code;
  final String message;
  final T? data;
  final String? errorId;

  const ApiResult({
    required this.code,
    required this.message,
    this.data,
    this.errorId,
  });

  bool get isSuccess => code == 200;

  /// 给 UI 展示的文案：500 用固定话术 + errorId，避免暴露内部细节。
  String get displayMessage {
    if (code == 500) {
      final id = errorId;
      if (id != null && id.isNotEmpty) {
        return '服务异常，请稍后重试（编号：$id）';
      }
      return '服务异常，请稍后重试';
    }
    if (message.isNotEmpty) return message;
    return '操作失败';
  }

  factory ApiResult.fromJson(
    Map<String, dynamic> json,
    T? Function(dynamic json) fromJsonT,
  ) {
    return ApiResult(
      code: json['code'] as int? ?? 500,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errorId: json['errorId'] as String?,
    );
  }
}
