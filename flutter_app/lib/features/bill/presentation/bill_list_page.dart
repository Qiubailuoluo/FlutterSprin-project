import 'package:flutter/material.dart';
import 'package:ledger/core/di/app_services.dart';
import 'package:ledger/core/feedback/app_messenger.dart';
import 'package:ledger/core/widgets/async_state_view.dart';
import 'package:ledger/core/widgets/confirm_dialog.dart';
import 'package:ledger/core/widgets/page_header.dart';
import 'package:ledger/features/bill/data/bill_api.dart';
import 'package:ledger/features/bill/data/models/bill_item.dart';
import 'package:ledger/features/bill/data/models/bill_page.dart' as models;
import 'package:ledger/features/bill/presentation/widgets/bill_form_dialog.dart';

/// 账单列表页：分页展示、筛选、增删改。
class BillListPage extends StatefulWidget {
  const BillListPage({super.key});

  @override
  State<BillListPage> createState() => _BillListPageState();
}

class _BillListPageState extends State<BillListPage> {
  final BillApi _billApi = AppServices.instance.billApi;

  models.BillPage? _pageData;
  bool _loading = true;
  String? _error;

  int _currentPage = 1;
  static const _pageSize = 20;

  /// null = 全部，1 = 收入，2 = 支出
  int? _filterType;

  @override
  void initState() {
    super.initState();
    _loadBills();
  }

  Future<void> _loadBills({int? page}) async {
    final targetPage = page ?? _currentPage;
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await _billApi.page(
      page: targetPage,
      size: _pageSize,
      type: _filterType,
    );

    if (!mounted) return;

    setState(() {
      _loading = false;
      if (result.isSuccess && result.data != null) {
        _pageData = result.data;
        _currentPage = result.data!.page;
      } else {
        _error = result.message.isNotEmpty ? result.message : '加载账单失败';
      }
    });
  }

  void _onFilterChanged(int? type) {
    if (_filterType == type) return;
    setState(() => _filterType = type);
    _loadBills(page: 1);
  }

  Future<void> _openForm({BillItem? bill}) async {
    final saved = await showBillFormDialog(context: context, initial: bill);
    if (saved == true) {
      AppMessenger.showSuccess(bill == null ? '账单已创建' : '账单已更新');
      await _loadBills();
    }
  }

  Future<void> _confirmDelete(BillItem bill) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: '删除账单',
      message: '确定删除「${bill.categoryName} ¥${bill.amount}」吗？',
      confirmText: '删除',
      destructive: true,
    );

    if (!confirmed || !mounted) return;

    final result = await _billApi.delete(bill.id);
    if (!mounted) return;

    if (result.isSuccess) {
      AppMessenger.showSuccess('已删除');
      await _loadBills();
    } else {
      AppMessenger.showError(
        result.message.isNotEmpty ? result.message : '删除失败',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final records = _pageData?.records ?? [];
    final isEmpty = !_loading && _error == null && records.isEmpty;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: '账单管理',
            actions: [
              FilledButton.icon(
                onPressed: () => _openForm(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('新增账单'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SegmentedButton<int?>(
                segments: const [
                  ButtonSegment(value: null, label: Text('全部')),
                  ButtonSegment(value: 1, label: Text('收入')),
                  ButtonSegment(value: 2, label: Text('支出')),
                ],
                selected: {_filterType},
                onSelectionChanged: (value) => _onFilterChanged(value.first),
              ),
              const Spacer(),
              IconButton(
                tooltip: '刷新',
                onPressed: _loading ? null : () => _loadBills(),
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: AsyncStateView(
                loading: _loading && _pageData == null,
                error: _error,
                onRetry: _loadBills,
                isEmpty: isEmpty,
                emptyMessage: '暂无账单',
                emptyIcon: Icons.receipt_long_outlined,
                emptyAction: OutlinedButton(
                  onPressed: () => _openForm(),
                  child: const Text('新增第一笔'),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('日期')),
                              DataColumn(label: Text('分类')),
                              DataColumn(label: Text('类型')),
                              DataColumn(label: Text('金额')),
                              DataColumn(label: Text('备注')),
                              DataColumn(label: Text('操作')),
                            ],
                            rows: records
                                .map((bill) => _buildRow(context, bill))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                    if (_pageData != null) _buildPagination(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildRow(BuildContext context, BillItem bill) {
    final isIncome = bill.type == 1;
    final amountColor =
        isIncome ? Colors.green.shade700 : Colors.orange.shade700;

    return DataRow(
      cells: [
        DataCell(Text(bill.billDate)),
        DataCell(Text(bill.categoryName)),
        DataCell(
          Chip(
            label: Text(bill.typeLabel),
            visualDensity: VisualDensity.compact,
            backgroundColor:
                isIncome ? Colors.green.shade50 : Colors.orange.shade50,
          ),
        ),
        DataCell(
          Text(
            '¥${bill.amount}',
            style: TextStyle(
              color: amountColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        DataCell(Text(bill.remark ?? '-')),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: '编辑',
                icon: const Icon(Icons.edit_outlined, size: 20),
                onPressed: () => _openForm(bill: bill),
              ),
              IconButton(
                tooltip: '删除',
                icon: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: Colors.red.shade400,
                ),
                onPressed: () => _confirmDelete(bill),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPagination(BuildContext context) {
    final data = _pageData!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Text('共 ${data.total} 条，第 ${data.page}/${data.totalPages} 页'),
          const Spacer(),
          IconButton(
            tooltip: '上一页',
            onPressed: data.page > 1 && !_loading
                ? () => _loadBills(page: data.page - 1)
                : null,
            icon: const Icon(Icons.chevron_left),
          ),
          IconButton(
            tooltip: '下一页',
            onPressed: data.page < data.totalPages && !_loading
                ? () => _loadBills(page: data.page + 1)
                : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
