/// 登录成功响应，对应 docs/api/auth.md LoginVO。
class LoginResponse {
  final String token;
  final int expiresIn;
  final int userId;
  final String username;
  final String nickname;

  const LoginResponse({
    required this.token,
    required this.expiresIn,
    required this.userId,
    required this.username,
    required this.nickname,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      expiresIn: json['expiresIn'] as int,
      userId: (json['userId'] as num).toInt(),
      username: json['username'] as String,
      nickname: json['nickname'] as String? ?? json['username'] as String,
    );
  }
}
