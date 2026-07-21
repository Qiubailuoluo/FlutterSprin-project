/// 家庭成员。
class MemberItem {
  final int id;
  final String name;
  final String? createdAt;

  const MemberItem({
    required this.id,
    required this.name,
    this.createdAt,
  });

  factory MemberItem.fromJson(Map<String, dynamic> json) {
    return MemberItem(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      createdAt: json['createdAt']?.toString(),
    );
  }
}
