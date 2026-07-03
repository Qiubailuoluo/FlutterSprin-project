import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ledger/app/router/app_router.dart';
import 'package:ledger/core/di/app_services.dart';
import 'package:ledger/features/auth/application/auth_session.dart';

/// 应用外壳：侧边栏 + 顶栏 + 内容区。
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static const _menuItems = [
    _MenuItem(icon: Icons.home_outlined, label: '首页', route: AppRoutes.home),
    _MenuItem(
      icon: Icons.category_outlined,
      label: '分类',
      route: AppRoutes.categories,
    ),
  ];

  AuthSession get _auth => AppServices.instance.authSession;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return ListenableBuilder(
      listenable: _auth,
      builder: (context, _) {
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                extended: MediaQuery.sizeOf(context).width > 900,
                selectedIndex: _selectedIndex(location),
                onDestinationSelected: (index) {
                  context.go(_menuItems[index].route);
                },
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Icon(
                    Icons.account_balance_wallet,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                destinations: [
                  for (final item in _menuItems)
                    NavigationRailDestination(
                      icon: Icon(item.icon),
                      label: Text(item.label),
                    ),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: Column(
                  children: [
                    _TopBar(
                      title: _titleForLocation(location),
                      nickname: _auth.user?.nickname,
                      onLogout: () async {
                        await _auth.logout();
                        if (context.mounted) context.go(AppRoutes.login);
                      },
                    ),
                    Expanded(child: child),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int _selectedIndex(String location) {
    final index = _menuItems.indexWhere((m) => location.startsWith(m.route));
    return index >= 0 ? index : 0;
  }

  String _titleForLocation(String location) {
    if (location.startsWith(AppRoutes.home)) return '首页';
    if (location.startsWith(AppRoutes.categories)) return '分类管理';
    return '小账本';
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    this.nickname,
    required this.onLogout,
  });

  final String title;
  final String? nickname;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            if (nickname != null) ...[
              Icon(Icons.person_outline, size: 18, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(nickname!, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(width: 16),
            ],
            TextButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('退出'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String route;
}
