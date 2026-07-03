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

  /// 统计接口，见 docs/api/stats.md
  static const String statsMonthPath = '/api/stats/month';

  /// 分类接口，见 docs/api/category.md
  static const String categoriesPath = '/api/categories';

  /// 账单接口，见 docs/api/bill.md
  static const String billsPath = '/api/bills';
}
