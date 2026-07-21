import 'package:flutter/material.dart';
import 'package:ledger/core/model/api_result.dart';

/// 全局 SnackBar 反馈，统一成功/错误/提示样式。
///
/// 需在 [MaterialApp.scaffoldMessengerKey] 中注册 [messengerKey]。
class AppMessenger {
  AppMessenger._();

  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void showSuccess(String message) {
    _show(message, backgroundColor: const Color(0xFF52C41A));
  }

  static void showError(String message) {
    _show(message, backgroundColor: const Color(0xFFFF4D4F));
  }

  /// 按 [ApiResult.displayMessage] 展示错误（500 带编号，业务用 message）。
  static void showApiError(ApiResult<dynamic> result) {
    showError(result.displayMessage);
  }

  static void showInfo(String message) {
    _show(message);
  }

  static void _show(
    String message, {
    Color? backgroundColor,
  }) {
    final messenger = messengerKey.currentState;
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
