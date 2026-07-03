import 'package:flutter_test/flutter_test.dart';
import 'package:ledger/core/di/app_services.dart';
import 'test_helpers.dart';

/// 登录集成测试：需要 backend 运行，且 testuser 已注册。
void main() {
  setUp(() async {
    await initIntegrationTestServices();
  });

  test('login with testuser succeeds', () async {
    final api = AppServices.instance.authApi;
    final result = await api.login(
      username: 'testuser',
      password: '123456',
    );
    expect(result.isSuccess, true, reason: result.message);
    expect(result.data?.token.isNotEmpty, true);
  });
}
