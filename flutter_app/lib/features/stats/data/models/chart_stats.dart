class CategoryShareItem {
  final int categoryId;
  final String categoryName;
  final String amount;
  final double ratio;

  const CategoryShareItem({
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.ratio,
  });

  factory CategoryShareItem.fromJson(Map<String, dynamic> json) {
    return CategoryShareItem(
      categoryId: (json['categoryId'] as num?)?.toInt() ?? 0,
      categoryName: json['categoryName'] as String? ?? '',
      amount: json['amount']?.toString() ?? '0.00',
      ratio: (json['ratio'] as num?)?.toDouble() ?? 0,
    );
  }
}

class TrendPoint {
  final int year;
  final int month;
  final String income;
  final String expense;

  const TrendPoint({
    required this.year,
    required this.month,
    required this.income,
    required this.expense,
  });

  factory TrendPoint.fromJson(Map<String, dynamic> json) {
    return TrendPoint(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      income: json['income']?.toString() ?? '0.00',
      expense: json['expense']?.toString() ?? '0.00',
    );
  }

  String get label => '$month月';
}

class MemberStatItem {
  final int? memberId;
  final String memberName;
  final String income;
  final String expense;

  const MemberStatItem({
    required this.memberId,
    required this.memberName,
    required this.income,
    required this.expense,
  });

  factory MemberStatItem.fromJson(Map<String, dynamic> json) {
    return MemberStatItem(
      memberId: (json['memberId'] as num?)?.toInt(),
      memberName: json['memberName'] as String? ?? '',
      income: json['income']?.toString() ?? '0.00',
      expense: json['expense']?.toString() ?? '0.00',
    );
  }
}
