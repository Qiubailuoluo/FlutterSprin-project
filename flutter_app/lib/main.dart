import 'package:flutter/material.dart';
import 'package:ledger/app/app.dart';
import 'package:ledger/core/di/app_services.dart';

/// 应用入口：初始化服务后启动。
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppServices.instance.init();
  runApp(const LedgerApp());
}
