/// 用户资料，对应 docs/api/auth.md UserProfile。
class UserProfile {
  final int userId;
  final String username;
  final String nickname;
  /// 1 正常，0 禁用
  final int status;
  /// 1 普通，2 管理员
  final int role;
  final String? createdAt;

  const UserProfile({
    required this.userId,
    required this.username,
    required this.nickname,
    this.status = 1,
    this.role = 1,
    this.createdAt,
  });

  bool get isAdmin => role == 2;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: (json['userId'] as num?)?.toInt() ??
          (json['id'] as num?)?.toInt() ??
          0,
      username: json['username'] as String? ?? '',
      nickname: json['nickname'] as String? ?? json['username'] as String? ?? '',
      status: (json['status'] as num?)?.toInt() ?? 1,
      role: (json['role'] as num?)?.toInt() ?? 1,
      createdAt: json['createdAt']?.toString(),
    );
  }
}
