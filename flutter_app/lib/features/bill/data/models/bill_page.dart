import 'package:ledger/features/bill/data/models/bill_item.dart';

/// 账单分页结果，对应 docs/api/bill.md 分页响应。
class BillPage {
  final int total;
  final int page;
  final int size;
  final List<BillItem> records;

  const BillPage({
    required this.total,
    required this.page,
    required this.size,
    required this.records,
  });

  /// 总页数
  int get totalPages => size > 0 ? (total + size - 1) ~/ size : 0;

  factory BillPage.fromJson(Map<String, dynamic> json) {
    return BillPage(
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      size: (json['size'] as num?)?.toInt() ?? 20,
      records: (json['records'] as List? ?? [])
          .map((e) => BillItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
