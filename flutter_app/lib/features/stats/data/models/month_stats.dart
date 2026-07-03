/// 月度统计，对应 docs/api/stats.md MonthStatsVO。
class MonthStats {
  final int year;
  final int month;

  /// 当月收入合计，保留两位小数的字符串
  final String income;

  /// 当月支出合计
  final String expense;

  /// 结余 = income - expense
  final String balance;

  const MonthStats({
    required this.year,
    required this.month,
    required this.income,
    required this.expense,
    required this.balance,
  });

  /// 展示用月份标签，如「2026年7月」
  String get monthLabel => '$year年$month月';

  factory MonthStats.fromJson(Map<String, dynamic> json) {
    return MonthStats(
      year: (json['year'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      income: json['income']?.toString() ?? '0.00',
      expense: json['expense']?.toString() ?? '0.00',
      balance: json['balance']?.toString() ?? '0.00',
    );
  }
}
