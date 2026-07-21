import 'package:go_router/go_router.dart';
import 'package:ledger/features/auth/application/auth_session.dart';
import 'package:ledger/features/auth/presentation/login_page.dart';
import 'package:ledger/features/auth/presentation/register_page.dart';
import 'package:ledger/features/bill/presentation/bill_list_page.dart';
import 'package:ledger/features/category/presentation/category_page.dart';
import 'package:ledger/features/home/presentation/home_page.dart';
import 'package:ledger/features/shell/presentation/app_shell.dart';
import 'package:ledger/features/stats/presentation/stats_page.dart';
import 'package:ledger/features/admin/presentation/admin_users_page.dart';

/// 路由路径常量。
class AppRoutes {
  AppRoutes._();

  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const categories = '/categories';
  static const bills = '/bills';
  static const stats = '/stats';
  static const adminUsers = '/admin/users';
}

/// 应用路由，含登录守卫（refreshListenable + redirect）。
class AppRouter {
  AppRouter._();

  /// 创建 GoRouter，需传入 [AuthSession] 以监听登录态变化。
  static GoRouter create(AuthSession authSession) {
    return GoRouter(
      initialLocation: AppRoutes.login,
      refreshListenable: authSession,
      redirect: (context, state) {
        final loggedIn = authSession.isLoggedIn;
        final path = state.matchedLocation;
        final isAuthPage =
            path == AppRoutes.login || path == AppRoutes.register;

        if (!loggedIn && !isAuthPage) return AppRoutes.login;
        if (loggedIn && isAuthPage) return AppRoutes.home;
        if (loggedIn &&
            path == AppRoutes.adminUsers &&
            !authSession.isAdmin) {
          return AppRoutes.home;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => const RegisterPage(),
        ),
        ShellRoute(
          builder: (context, state, child) => AppShell(child: child),
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomePage(),
            ),
            GoRoute(
              path: AppRoutes.categories,
              builder: (context, state) => const CategoryPage(),
            ),
            GoRoute(
              path: AppRoutes.bills,
              builder: (context, state) => const BillListPage(),
            ),
            GoRoute(
              path: AppRoutes.stats,
              builder: (context, state) => const StatsPage(),
            ),
            GoRoute(
              path: AppRoutes.adminUsers,
              builder: (context, state) => const AdminUsersPage(),
            ),
          ],
        ),
      ],
    );
  }
}
