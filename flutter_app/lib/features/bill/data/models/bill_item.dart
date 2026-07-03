/// 账单项，对应 docs/api/bill.md BillVO。
class BillItem {
  final int id;
  final int categoryId;
  final String categoryName;

  /// 1 = 收入，2 = 支出
  final int type;

  /// 金额字符串，保留两位小数
  final String amount;
  final String billDate;
  final String? remark;
  final String? createdAt;

  const BillItem({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.type,
    required this.amount,
    required this.billDate,
    this.remark,
    this.createdAt,
  });

  String get typeLabel => type == 1 ? '收入' : '支出';

  factory BillItem.fromJson(Map<String, dynamic> json) {
    return BillItem(
      id: (json['id'] as num).toInt(),
      categoryId: (json['categoryId'] as num).toInt(),
      categoryName: json['categoryName'] as String? ?? '',
      type: (json['type'] as num).toInt(),
      amount: json['amount']?.toString() ?? '0.00',
      billDate: json['billDate']?.toString() ?? '',
      remark: json['remark'] as String?,
      createdAt: json['createdAt']?.toString(),
    );
  }
}
