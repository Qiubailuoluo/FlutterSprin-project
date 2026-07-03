import 'package:flutter/material.dart';
import 'package:ledger/core/di/app_services.dart';
import 'package:ledger/features/category/data/category_api.dart';
import 'package:ledger/features/category/data/models/category_item.dart';

/// 分类管理页：查看系统/自定义分类，新增与删除自定义分类。
class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final CategoryApi _categoryApi = AppServices.instance.categoryApi;

  /// null = 全部，1 = 收入，2 = 支出
  int? _filterType;
  List<CategoryItem> _items = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await _categoryApi.list(type: _filterType);
    if (!mounted) return;

    setState(() {
      _loading = false;
      if (result.isSuccess && result.data != null) {
        _items = result.data!;
      } else {
        _error = result.message.isNotEmpty ? result.message : '加载分类失败';
      }
    });
  }

  void _onFilterChanged(int? type) {
    if (_filterType == type) return;
    setState(() => _filterType = type);
    _loadCategories();
  }

  Future<void> _showCreateDialog() async {
    final nameController = TextEditingController();
    var selectedType = 2;

    final created = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('新增自定义分类'),
              content: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: '分类名称',
                        hintText: '如：宠物、健身',
                      ),
                      autofocus: true,
                    ),
                    const SizedBox(height: 16),
                    SegmentedButton<int>(
                      segments: const [
                        ButtonSegment(value: 1, label: Text('收入')),
                        ButtonSegment(value: 2, label: Text('支出')),
                      ],
                      selected: {selectedType},
                      onSelectionChanged: (value) {
                        setDialogState(() => selectedType = value.first);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('取消'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('确定'),
                ),
              ],
            );
          },
        );
      },
    );

    if (created != true || !mounted) return;

    final name = nameController.text.trim();
    if (name.isEmpty) {
      _showSnack('请输入分类名称');
      return;
    }

    final result = await _categoryApi.create(name: name, type: selectedType);
    if (!mounted) return;

    if (result.isSuccess) {
      _showSnack('已添加分类「$name」');
      await _loadCategories();
    } else {
      _showSnack(result.message.isNotEmpty ? result.message : '添加失败');
    }
  }

  Future<void> _confirmDelete(CategoryItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除分类'),
        content: Text('确定删除自定义分类「${item.name}」吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final result = await _categoryApi.delete(item.id);
    if (!mounted) return;

    if (result.isSuccess) {
      _showSnack('已删除「${item.name}」');
      await _loadCategories();
    } else {
      _showSnack(result.message.isNotEmpty ? result.message : '删除失败');
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('分类管理', style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              FilledButton.icon(
                onPressed: _showCreateDialog,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('新增分类'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SegmentedButton<int?>(
            segments: const [
              ButtonSegment(value: null, label: Text('全部')),
              ButtonSegment(value: 1, label: Text('收入')),
              ButtonSegment(value: 2, label: Text('支出')),
            ],
            selected: {_filterType},
            onSelectionChanged: (value) => _onFilterChanged(value.first),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: _buildBody(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),
            const SizedBox(height: 12),
            FilledButton(onPressed: _loadCategories, child: const Text('重试')),
          ],
        ),
      );
    }

    if (_items.isEmpty) {
      return const Center(child: Text('暂无分类'));
    }

    return ListView.separated(
      itemCount: _items.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, color: Colors.grey.shade200),
      itemBuilder: (context, index) {
        final item = _items[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: item.type == 1
                ? Colors.green.shade50
                : Colors.orange.shade50,
            child: Icon(
              item.type == 1 ? Icons.add : Icons.remove,
              size: 18,
              color: item.type == 1
                  ? Colors.green.shade700
                  : Colors.orange.shade700,
            ),
          ),
          title: Text(item.name),
          subtitle: Text(
            '${item.typeLabel} · ${item.system ? '系统预设' : '自定义'}',
          ),
          trailing: item.system
              ? Chip(
                  label: const Text('系统'),
                  visualDensity: VisualDensity.compact,
                  backgroundColor: Colors.grey.shade100,
                )
              : IconButton(
                  tooltip: '删除',
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                  onPressed: () => _confirmDelete(item),
                ),
        );
      },
    );
  }
}
