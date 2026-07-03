/// 分类项，对应 docs/api/category.md CategoryVO。
class CategoryItem {
  final int id;
  final String name;

  /// 1 = 收入，2 = 支出
  final int type;

  /// true = 系统预设，false = 用户自定义
  final bool system;
  final int sortOrder;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.type,
    required this.system,
    required this.sortOrder,
  });

  /// 类型中文标签
  String get typeLabel => type == 1 ? '收入' : '支出';

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      type: (json['type'] as num).toInt(),
      system: json['system'] as bool? ?? false,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }
}
