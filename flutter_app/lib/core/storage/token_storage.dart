import 'package:shared_preferences/shared_preferences.dart';

/// Token 本地存储（Web 使用 shared_preferences）。
///
/// 登录成功后写入，退出时清除；DioClient 拦截器自动读取。
class TokenStorage {
  static const _tokenKey = 'auth_token';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
