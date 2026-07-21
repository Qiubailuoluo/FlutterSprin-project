import 'package:flutter/material.dart';
import 'package:ledger/app/theme/app_theme.dart';
import 'package:ledger/core/di/app_services.dart';
import 'package:ledger/core/feedback/app_messenger.dart';
import 'package:ledger/core/l10n/app_strings.dart';

/// 应用根 Widget：主题 + 路由 + 语言切换。
class LedgerApp extends StatelessWidget {
  const LedgerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppServices.instance.locale;
    return ListenableBuilder(
      listenable: locale,
      builder: (context, _) {
        final lang = locale.language;
        return MaterialApp.router(
          title: AppStrings.t(lang, 'app.title'),
          theme: AppTheme.light,
          scaffoldMessengerKey: AppMessenger.messengerKey,
          routerConfig: AppServices.instance.router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
