import 'package:flutter_test/flutter_test.dart';
import 'package:ledger/core/di/app_services.dart';
import 'test_helpers.dart';

/// 统计与分类集成测试：需 backend 运行且 testuser 已登录。
void main() {
  setUp(() async {
    await initIntegrationTestServices();
    final login = await AppServices.instance.authApi.login(
      username: 'testuser',
      password: '123456',
    );
    expect(login.isSuccess, true, reason: login.message);
    await AppServices.instance.tokenStorage.saveToken(login.data!.token);
  });

  test('month stats returns income expense balance', () async {
    final result = await AppServices.instance.statsApi.getMonthStats();
    expect(result.isSuccess, true, reason: result.message);
    expect(result.data?.year, isNotNull);
    expect(result.data?.month, isNotNull);
    expect(result.data?.income, isNotEmpty);
    expect(result.data?.expense, isNotEmpty);
    expect(result.data?.balance, isNotEmpty);
  });

  test('categories list returns system categories', () async {
    final result = await AppServices.instance.categoryApi.list();
    expect(result.isSuccess, true, reason: result.message);
    expect(result.data, isNotEmpty);
    expect(result.data!.any((c) => c.system), true);
  });
}
