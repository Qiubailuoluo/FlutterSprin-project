import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ledger/app/router/app_router.dart';
import 'package:ledger/core/di/app_services.dart';
import 'package:ledger/core/feedback/app_messenger.dart';
import 'package:ledger/core/l10n/app_strings.dart';
import 'package:ledger/features/auth/application/auth_session.dart';
import 'package:ledger/features/auth/presentation/widgets/profile_dialog.dart';

/// 应用外壳：侧边栏 + 顶栏 + 内容区。
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  AuthSession get _auth => AppServices.instance.authSession;

  List<_MenuItem> _menuItems(BuildContext context) {
    final lang = AppServices.instance.locale.language;
    final items = <_MenuItem>[
      _MenuItem(
        icon: Icons.home_outlined,
        label: '首页',
        route: AppRoutes.home,
      ),
      _MenuItem(
        icon: Icons.receipt_long_outlined,
        label: '账单',
        route: AppRoutes.bills,
      ),
      _MenuItem(
        icon: Icons.pie_chart_outline,
        label: AppStrings.t(lang, 'nav.stats'),
        route: AppRoutes.stats,
      ),
      _MenuItem(
        icon: Icons.category_outlined,
        label: '分类',
        route: AppRoutes.categories,
      ),
    ];
    if (_auth.isAdmin) {
      items.add(
        _MenuItem(
          icon: Icons.manage_accounts_outlined,
          label: '账户管理',
          route: AppRoutes.adminUsers,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return ListenableBuilder(
      listenable: Listenable.merge([_auth, AppServices.instance.locale]),
      builder: (context, _) {
        final items = _menuItems(context);
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                extended: MediaQuery.sizeOf(context).width > 900,
                selectedIndex: _selectedIndex(location, items),
                onDestinationSelected: (index) {
                  context.go(items[index].route);
                },
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Icon(
                    Icons.account_balance_wallet,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                destinations: [
                  for (final item in items)
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
                      onEditProfile: () => showProfileDialog(context),
                      onLogout: () async {
                        await _auth.logout();
                        if (context.mounted) {
                          AppMessenger.showInfo('已退出登录');
                          context.go(AppRoutes.login);
                        }
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

  int _selectedIndex(String location, List<_MenuItem> items) {
    final index = items.indexWhere((m) => location.startsWith(m.route));
    return index >= 0 ? index : 0;
  }

  String _titleForLocation(String location) {
    final lang = AppServices.instance.locale.language;
    if (location.startsWith(AppRoutes.home)) return '首页';
    if (location.startsWith(AppRoutes.bills)) return '账单管理';
    if (location.startsWith(AppRoutes.stats)) {
      return AppStrings.t(lang, 'stats.title');
    }
    if (location.startsWith(AppRoutes.categories)) return '分类管理';
    if (location.startsWith(AppRoutes.adminUsers)) return '账户管理';
    return '小账本';
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    this.nickname,
    required this.onEditProfile,
    required this.onLogout,
  });

  final String title;
  final String? nickname;
  final VoidCallback onEditProfile;
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
              TextButton.icon(
                onPressed: onEditProfile,
                icon: Icon(Icons.person_outline, size: 18, color: Colors.grey.shade600),
                label: Text(nickname!, style: Theme.of(context).textTheme.bodyMedium),
              ),
              const SizedBox(width: 8),
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
