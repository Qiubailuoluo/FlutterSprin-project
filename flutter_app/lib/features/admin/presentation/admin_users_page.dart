import 'package:flutter/material.dart';
import 'package:ledger/core/di/app_services.dart';
import 'package:ledger/core/feedback/app_messenger.dart';
import 'package:ledger/core/widgets/async_state_view.dart';
import 'package:ledger/core/widgets/confirm_dialog.dart';
import 'package:ledger/core/widgets/page_header.dart';
import 'package:ledger/features/admin/data/admin_user_api.dart';
import 'package:ledger/features/admin/data/models/admin_user_item.dart';

/// 账户管理：管理员查看全部用户并封禁 / 解封。
class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  final AdminUserApi _api = AppServices.instance.adminUserApi;

  List<AdminUserItem> _items = [];
  bool _loading = true;
  String? _error;

  int? get _selfId => AppServices.instance.authSession.user?.userId;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await _api.list();
    if (!mounted) return;
    setState(() {
      _loading = false;
      if (result.isSuccess && result.data != null) {
        _items = result.data!;
      } else {
        _error = result.message.isNotEmpty ? result.message : '加载用户失败';
      }
    });
  }

  Future<void> _setStatus(AdminUserItem user, int status) async {
    final ban = status == 0;
    final ok = await showConfirmDialog(
      context: context,
      title: ban ? '封禁用户' : '解封用户',
      message: ban
          ? '确定封禁「${user.username}」？封禁后对方将无法登录。'
          : '确定解封「${user.username}」？',
      destructive: ban,
    );
    if (!ok) return;

    final result = await _api.updateStatus(id: user.id, status: status);
    if (!mounted) return;
    if (result.isSuccess) {
      AppMessenger.showSuccess(ban ? '已封禁' : '已解封');
      await _reload();
    } else {
      AppMessenger.showError(
        result.message.isNotEmpty ? result.message : '操作失败',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(
            title: '账户管理',
            actions: [
              IconButton(
                tooltip: '刷新',
                onPressed: _loading ? null : _reload,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: AsyncStateView(
              loading: _loading,
              error: _error,
              onRetry: _reload,
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.sizeOf(context).width - 280,
                    ),
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('用户名')),
                        DataColumn(label: Text('昵称')),
                        DataColumn(label: Text('角色')),
                        DataColumn(label: Text('状态')),
                        DataColumn(label: Text('注册时间')),
                        DataColumn(label: Text('操作')),
                      ],
                      rows: [
                        for (final u in _items)
                          DataRow(
                            cells: [
                              DataCell(Text('${u.id}')),
                              DataCell(Text(u.username)),
                              DataCell(Text(u.nickname)),
                              DataCell(Text(u.roleLabel)),
                              DataCell(
                                Text(
                                  u.statusLabel,
                                  style: TextStyle(
                                    color: u.isBanned
                                        ? Colors.red.shade700
                                        : Colors.green.shade700,
                                  ),
                                ),
                              ),
                              DataCell(Text(u.createdAt ?? '-')),
                              DataCell(
                                u.id == _selfId
                                    ? const Text('-')
                                    : TextButton(
                                        onPressed: () => _setStatus(
                                          u,
                                          u.isBanned ? 1 : 0,
                                        ),
                                        child: Text(u.isBanned ? '解封' : '封禁'),
                                      ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
