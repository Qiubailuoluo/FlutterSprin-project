import 'package:flutter/material.dart';
import 'package:ledger/core/di/app_services.dart';
import 'package:ledger/features/bill/data/bill_api.dart';
import 'package:ledger/features/bill/data/models/bill_item.dart';
import 'package:ledger/features/category/data/category_api.dart';
import 'package:ledger/features/category/data/models/category_item.dart';

/// 账单新增/编辑表单对话框。
///
/// 返回 `true` 表示保存成功，应刷新列表。
Future<bool?> showBillFormDialog({
  required BuildContext context,
  BillItem? initial,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => _BillFormDialog(initial: initial),
  );
}

class _BillFormDialog extends StatefulWidget {
  const _BillFormDialog({this.initial});

  final BillItem? initial;

  @override
  State<_BillFormDialog> createState() => _BillFormDialogState();
}

class _BillFormDialogState extends State<_BillFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _remarkController = TextEditingController();

  final BillApi _billApi = AppServices.instance.billApi;
  final CategoryApi _categoryApi = AppServices.instance.categoryApi;

  late int _type;
  int? _categoryId;
  DateTime _billDate = DateTime.now();
  List<CategoryItem> _categories = [];
  bool _loadingCategories = true;
  bool _submitting = false;

  bool get _isEdit => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _type = initial?.type ?? 2;
    _categoryId = initial?.categoryId;
    if (initial != null) {
      _amountController.text = initial.amount;
      _remarkController.text = initial.remark ?? '';
      _billDate = DateTime.tryParse(initial.billDate) ?? DateTime.now();
    }
    _loadCategories();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() => _loadingCategories = true);
    final result = await _categoryApi.list(type: _type);
    if (!mounted) return;

    final categories = result.data ?? [];
    setState(() {
      _loadingCategories = false;
      _categories = categories;
      if (_categoryId != null &&
          !categories.any((c) => c.id == _categoryId)) {
        _categoryId = categories.isNotEmpty ? categories.first.id : null;
      } else if (_categoryId == null && categories.isNotEmpty) {
        _categoryId = categories.first.id;
      }
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _billDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _billDate = picked);
    }
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_categoryId == null) {
      _showError('请选择分类');
      return;
    }

    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      _showError('请输入有效金额');
      return;
    }

    setState(() => _submitting = true);

    final billDate = _formatDate(_billDate);
    final remark = _remarkController.text.trim();

    final result = _isEdit
        ? await _billApi.update(
            id: widget.initial!.id,
            categoryId: _categoryId,
            type: _type,
            amount: amount,
            billDate: billDate,
            remark: remark.isEmpty ? '' : remark,
          )
        : await _billApi.create(
            categoryId: _categoryId!,
            type: _type,
            amount: amount,
            billDate: billDate,
            remark: remark.isEmpty ? null : remark,
          );

    if (!mounted) return;
    setState(() => _submitting = false);

    if (result.isSuccess) {
      Navigator.pop(context, true);
    } else {
      _showError(result.message.isNotEmpty ? result.message : '保存失败');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? '编辑账单' : '新增账单'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 1, label: Text('收入')),
                    ButtonSegment(value: 2, label: Text('支出')),
                  ],
                  selected: {_type},
                  onSelectionChanged: (value) {
                    setState(() {
                      _type = value.first;
                      _categoryId = null;
                    });
                    _loadCategories();
                  },
                ),
                const SizedBox(height: 16),
                if (_loadingCategories)
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(),
                  )
                else
                  DropdownButtonFormField<int>(
                    key: ValueKey('category-$_type-$_categoryId'),
                    initialValue: _categoryId,
                    decoration: const InputDecoration(labelText: '分类'),
                    items: _categories
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _categoryId = value),
                    validator: (value) =>
                        value == null ? '请选择分类' : null,
                  ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: '金额',
                    prefixText: '¥ ',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    final amount = double.tryParse(value?.trim() ?? '');
                    if (amount == null || amount <= 0) return '金额必须大于 0';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: '账单日期',
                      suffixIcon: Icon(Icons.calendar_today, size: 18),
                    ),
                    child: Text(_formatDate(_billDate)),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _remarkController,
                  decoration: const InputDecoration(labelText: '备注（可选）'),
                  maxLength: 255,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_isEdit ? '保存' : '创建'),
        ),
      ],
    );
  }
}
