import 'package:flutter_test/flutter_test.dart';
import 'package:ledger/core/di/app_services.dart';
import 'test_helpers.dart';

/// 账单集成测试：需 backend 运行且 testuser 已登录。
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

  test('bills page returns paged result', () async {
    final result = await AppServices.instance.billApi.page(page: 1, size: 10);
    expect(result.isSuccess, true, reason: result.message);
    expect(result.data?.page, 1);
    expect(result.data?.records, isNotNull);
  });

  test('create and delete bill succeeds', () async {
    final categories = await AppServices.instance.categoryApi.list(type: 2);
    expect(categories.isSuccess, true);
    expect(categories.data, isNotEmpty);

    final categoryId = categories.data!.first.id;
    final create = await AppServices.instance.billApi.create(
      categoryId: categoryId,
      type: 2,
      amount: 12.34,
      billDate: '2026-07-01',
      remark: 'integration-test',
    );
    expect(create.isSuccess, true, reason: create.message);
    expect(create.data?.id, isNotNull);

    final delete = await AppServices.instance.billApi.delete(create.data!.id);
    expect(delete.isSuccess, true, reason: delete.message);
  });
}
