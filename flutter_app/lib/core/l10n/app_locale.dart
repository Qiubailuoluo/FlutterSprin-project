import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 应用支持的界面语言（练习 i18n：中 / 英 / 日）。
enum AppLanguage {
  zh,
  en,
  ja,
}

/// 全局语言状态；切换后 [notifyListeners]，由根 Widget 重建文案。
class AppLocaleController extends ChangeNotifier {
  static const _prefsKey = 'app_language';

  AppLanguage _language = AppLanguage.zh;

  AppLanguage get language => _language;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    _language = AppLanguage.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => AppLanguage.zh,
    );
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (_language == language) return;
    _language = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, language.name);
    notifyListeners();
  }
}
