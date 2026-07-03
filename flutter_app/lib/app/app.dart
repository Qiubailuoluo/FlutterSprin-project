import 'package:flutter/material.dart';
import 'package:ledger/app/theme/app_theme.dart';
import 'package:ledger/core/di/app_services.dart';
import 'package:ledger/core/feedback/app_messenger.dart';

/// 应用根 Widget：主题 + 路由。
class LedgerApp extends StatelessWidget {
  const LedgerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '小账本',
      theme: AppTheme.light,
      scaffoldMessengerKey: AppMessenger.messengerKey,
      routerConfig: AppServices.instance.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
