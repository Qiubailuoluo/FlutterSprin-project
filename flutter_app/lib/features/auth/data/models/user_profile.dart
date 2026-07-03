/// 用户资料，对应 docs/api/auth.md UserProfile。
class UserProfile {
  final int userId;
  final String username;
  final String nickname;
  final String? createdAt;

  const UserProfile({
    required this.userId,
    required this.username,
    required this.nickname,
    this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: (json['userId'] as num).toInt(),
      username: json['username'] as String,
      nickname: json['nickname'] as String? ?? json['username'] as String,
      createdAt: json['createdAt'] as String?,
    );
  }
}
