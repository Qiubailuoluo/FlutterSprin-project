/// API 与环境常量。
/// Web 开发时后端默认运行在 localhost:8080。
class ApiConstants {
  ApiConstants._();

  /// 后端基址，与 docs/dev-setup.md 保持一致
  static const String baseUrl = 'http://localhost:8080';

  static const String healthPath = '/api/health';

  /// 认证接口，见 docs/api/auth.md
  static const String registerPath = '/api/auth/register';
  static const String loginPath = '/api/auth/login';
  static const String logoutPath = '/api/auth/logout';
  static const String profilePath = '/api/user/profile';
  static const String passwordPath = '/api/user/password';

  /// 统计接口，见 docs/api/stats.md
  static const String statsMonthPath = '/api/stats/month';
  static const String statsCategorySharePath = '/api/stats/category-share';
  static const String statsTrendPath = '/api/stats/trend';
  static const String statsByMemberPath = '/api/stats/by-member';

  static const String membersPath = '/api/members';

  /// 分类接口，见 docs/api/category.md
  static const String categoriesPath = '/api/categories';

  /// 账单接口，见 docs/api/bill.md
  static const String billsPath = '/api/bills';

  /// 管理员账户，见 docs/api/admin-users.md
  static const String adminUsersPath = '/api/admin/users';
}
