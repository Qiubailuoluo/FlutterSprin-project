import 'package:flutter/material.dart';
import 'package:ledger/core/di/app_services.dart';
import 'package:ledger/core/feedback/app_messenger.dart';
import 'package:ledger/core/l10n/app_strings.dart';

/// 个人资料对话框：改昵称 / 改密码。
Future<void> showProfileDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => const _ProfileDialog(),
  );
}

class _ProfileDialog extends StatefulWidget {
  const _ProfileDialog();

  @override
  State<_ProfileDialog> createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<_ProfileDialog> {
  final _nicknameController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _savingNickname = false;
  bool _savingPassword = false;

  @override
  void initState() {
    super.initState();
    _nicknameController.text =
        AppServices.instance.authSession.user?.nickname ?? '';
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _saveNickname() async {
    final nickname = _nicknameController.text.trim();
    if (nickname.isEmpty) {
      AppMessenger.showError(
        AppStrings.t(AppServices.instance.locale.language, 'profile.nicknameRequired'),
      );
      return;
    }
    setState(() => _savingNickname = true);
    final err = await AppServices.instance.authSession.updateNickname(nickname);
    if (!mounted) return;
    setState(() => _savingNickname = false);
    if (err != null) {
      AppMessenger.showError(err);
      return;
    }
    AppMessenger.showSuccess(
      AppStrings.t(AppServices.instance.locale.language, 'profile.nicknameSaved'),
    );
  }

  Future<void> _savePassword() async {
    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    if (oldPassword.length < 6 || newPassword.length < 6) {
      AppMessenger.showError(
        AppStrings.t(AppServices.instance.locale.language, 'profile.passwordRule'),
      );
      return;
    }
    setState(() => _savingPassword = true);
    final err = await AppServices.instance.authSession.updatePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
    if (!mounted) return;
    setState(() => _savingPassword = false);
    if (err != null) {
      AppMessenger.showError(err);
      return;
    }
    Navigator.pop(context);
    AppMessenger.showSuccess(
      AppStrings.t(AppServices.instance.locale.language, 'profile.passwordChanged'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppServices.instance.locale.language;
    final username = AppServices.instance.authSession.user?.username ?? '';
    return AlertDialog(
      title: Text(AppStrings.t(lang, 'profile.title')),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('${AppStrings.t(lang, 'profile.username')}: $username'),
              const SizedBox(height: 16),
              TextField(
                controller: _nicknameController,
                decoration: InputDecoration(
                  labelText: AppStrings.t(lang, 'profile.nickname'),
                ),
                maxLength: 64,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: _savingNickname ? null : _saveNickname,
                  child: _savingNickname
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(AppStrings.t(lang, 'profile.saveNickname')),
                ),
              ),
              const Divider(height: 32),
              Text(
                AppStrings.t(lang, 'profile.changePassword'),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppStrings.t(lang, 'profile.oldPassword'),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppStrings.t(lang, 'profile.newPassword'),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: _savingPassword ? null : _savePassword,
                  child: _savingPassword
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(AppStrings.t(lang, 'profile.savePassword')),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppStrings.t(lang, 'common.cancel')),
        ),
      ],
    );
  }
}
