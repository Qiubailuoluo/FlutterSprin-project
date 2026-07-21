/// 管理员视角的用户项，对应 docs/api/admin-users.md。
class AdminUserItem {
  final int id;
  final String username;
  final String nickname;
  final int status;
  final int role;
  final String? createdAt;

  const AdminUserItem({
    required this.id,
    required this.username,
    required this.nickname,
    required this.status,
    required this.role,
    this.createdAt,
  });

  bool get isBanned => status == 0;
  bool get isAdmin => role == 2;

  String get statusLabel => isBanned ? '已封禁' : '正常';
  String get roleLabel => isAdmin ? '管理员' : '普通用户';

  factory AdminUserItem.fromJson(Map<String, dynamic> json) {
    return AdminUserItem(
      id: (json['id'] as num).toInt(),
      username: json['username'] as String? ?? '',
      nickname: json['nickname'] as String? ?? '',
      status: (json['status'] as num?)?.toInt() ?? 1,
      role: (json['role'] as num?)?.toInt() ?? 1,
      createdAt: json['createdAt']?.toString(),
    );
  }
}
