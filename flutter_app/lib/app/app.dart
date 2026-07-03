import 'package:flutter/material.dart';
import 'package:ledger/app/theme/app_theme.dart';
import 'package:ledger/core/di/app_services.dart';

/// 应用根 Widget：主题 + 路由。
class LedgerApp extends StatelessWidget {
  const LedgerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '小账本',
      theme: AppTheme.light,
      routerConfig: AppServices.instance.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
