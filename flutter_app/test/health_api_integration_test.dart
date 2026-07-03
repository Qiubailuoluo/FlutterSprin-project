import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledger/core/constants/api_constants.dart';
import 'package:ledger/core/model/api_result.dart';

/// 集成测试：需要 backend 在 localhost:8080 运行。
///
/// 直接使用 Dio，不经过 TokenStorage（单元测试环境无 shared_preferences 插件）。
void main() {
  test('health api returns UP when backend running', () async {
    final dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
    final response = await dio.get<Map<String, dynamic>>(ApiConstants.healthPath);
    final result = ApiResult.fromJson(
      response.data ?? {},
      (json) => (json as Map).map((k, v) => MapEntry(k.toString(), v.toString())),
    );
    expect(result.isSuccess, true);
    expect(result.data?['status'], 'UP');
    expect(result.data?['app'], 'ledger');
  });
}
