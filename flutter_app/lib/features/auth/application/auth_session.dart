import 'package:flutter/foundation.dart';
import 'package:ledger/core/storage/token_storage.dart';
import 'package:ledger/features/auth/data/auth_api.dart';
import 'package:ledger/features/auth/data/models/user_profile.dart';

/// 登录态管理：Token 持久化 + 内存用户信息 + 路由刷新通知。
///
/// 作为 [ChangeNotifier] 供 GoRouter [refreshListenable] 使用。
class AuthSession extends ChangeNotifier {
  AuthSession({
    required TokenStorage tokenStorage,
    AuthApi? authApi,
  })  : _tokenStorage = tokenStorage,
        _authApi = authApi ?? AuthApi();

  final TokenStorage _tokenStorage;
  final AuthApi _authApi;

  UserProfile? _user;

  /// 当前登录用户，未登录为 null。
  UserProfile? get user => _user;

  /// 是否已登录（Token 存在且已恢复用户信息）。
  bool get isLoggedIn => _user != null;

  /// 应用启动时从本地 Token 恢复会话，并校验 profile 接口。
  Future<void> restoreSession() async {
    final token = await _tokenStorage.getToken();
    if (token == null || token.isEmpty) {
      _user = null;
      notifyListeners();
      return;
    }
    final result = await _authApi.getProfile();
    if (result.isSuccess && result.data != null) {
      _user = result.data;
    } else {
      // Token 失效或后端拒绝，清除本地缓存
      await _tokenStorage.clearToken();
      _user = null;
    }
    notifyListeners();
  }

  /// 登录：保存 Token 与用户信息。
  Future<String?> login(String username, String password) async {
    final result = await _authApi.login(username: username, password: password);
    if (!result.isSuccess || result.data == null) {
      return result.message.isNotEmpty ? result.message : '登录失败';
    }
    final data = result.data!;
    await _tokenStorage.saveToken(data.token);
    _user = UserProfile(
      userId: data.userId,
      username: data.username,
      nickname: data.nickname,
    );
    notifyListeners();
    return null;
  }

  /// 注册成功后自动登录。
  Future<String?> register({
    required String username,
    required String password,
    String? nickname,
  }) async {
    final result = await _authApi.register(
      username: username,
      password: password,
      nickname: nickname,
    );
    if (!result.isSuccess) {
      return result.message.isNotEmpty ? result.message : '注册失败';
    }
    return login(username, password);
  }

  /// 退出：调用后端删除 Redis Token，并清除本地状态。
  Future<void> logout() async {
    try {
      await _authApi.logout();
    } finally {
      await _tokenStorage.clearToken();
      _user = null;
      notifyListeners();
    }
  }
}
