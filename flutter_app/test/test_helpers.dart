import 'package:flutter_test/flutter_test.dart';
import 'package:ledger/core/di/app_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Widget 测试初始化：Mock SharedPreferences + Widget 绑定。
///
/// 注意：启用 Widget 绑定后，所有 HTTP 会被拦截为 400，仅用于 UI 测试。
Future<void> initWidgetTestServices() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await AppServices.instance.init();
}

/// 集成测试初始化：仅 Mock SharedPreferences，保留真实 HTTP。
Future<void> initIntegrationTestServices() async {
  SharedPreferences.setMockInitialValues({});
  await AppServices.instance.init();
}
