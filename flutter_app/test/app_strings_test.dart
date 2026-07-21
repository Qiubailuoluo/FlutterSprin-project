import 'package:flutter_test/flutter_test.dart';
import 'package:ledger/core/l10n/app_locale.dart';
import 'package:ledger/core/l10n/app_strings.dart';

void main() {
  test('home.overview has zh/en/ja and differs by locale', () {
    final zh = AppStrings.t(AppLanguage.zh, 'home.overview');
    final en = AppStrings.t(AppLanguage.en, 'home.overview');
    final ja = AppStrings.t(AppLanguage.ja, 'home.overview');

    expect(zh, '本月概览');
    expect(en, 'This month');
    expect(ja, '今月の概要');
    expect(zh == en, isFalse);
    expect(en == ja, isFalse);
  });

  test('missing key falls back to en then key name', () {
    expect(AppStrings.t(AppLanguage.zh, 'home.overview'), isNotEmpty);
    expect(AppStrings.t(AppLanguage.zh, 'does.not.exist'), 'does.not.exist');
  });
  test('profile.title has zh/en/ja', () {
    expect(AppStrings.t(AppLanguage.zh, 'profile.title'), '个人资料');
    expect(AppStrings.t(AppLanguage.en, 'profile.title'), 'Profile');
    expect(AppStrings.t(AppLanguage.ja, 'profile.title'), 'プロフィール');
  });
}
