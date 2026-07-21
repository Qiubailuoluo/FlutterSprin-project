import 'package:ledger/core/feedback/app_messenger.dart';
import 'package:ledger/core/l10n/app_locale.dart';
import 'package:ledger/core/network/dio_client.dart';
import 'package:ledger/core/storage/token_storage.dart';
import 'package:ledger/features/auth/application/auth_session.dart';
import 'package:ledger/features/auth/data/auth_api.dart';
import 'package:ledger/features/bill/data/bill_api.dart';
import 'package:ledger/features/category/data/category_api.dart';
import 'package:ledger/features/member/data/member_api.dart';
import 'package:ledger/features/stats/data/stats_api.dart';
import 'package:ledger/features/admin/data/admin_user_api.dart';
import 'package:go_router/go_router.dart';
import 'package:ledger/app/router/app_router.dart';

/// 全局服务容器。
class AppServices {
  AppServices._() {
    dioClient = DioClient(
      tokenStorage,
      onUnauthorized: _handleUnauthorized,
    );
    authApi = AuthApi(client: dioClient);
    statsApi = StatsApi(client: dioClient);
    categoryApi = CategoryApi(client: dioClient);
    billApi = BillApi(client: dioClient);
    memberApi = MemberApi(client: dioClient);
    adminUserApi = AdminUserApi(client: dioClient);
    authSession = AuthSession(
      tokenStorage: tokenStorage,
      authApi: authApi,
    );
    router = AppRouter.create(authSession);
  }

  static final AppServices instance = AppServices._();

  final TokenStorage tokenStorage = TokenStorage();
  final AppLocaleController locale = AppLocaleController();
  late final DioClient dioClient;
  late final AuthApi authApi;
  late final StatsApi statsApi;
  late final CategoryApi categoryApi;
  late final BillApi billApi;
  late final MemberApi memberApi;
  late final AdminUserApi adminUserApi;
  late final AuthSession authSession;
  late final GoRouter router;

  bool _initialized = false;
  bool _handlingUnauthorized = false;

  /// 启动时恢复登录态与界面语言。
  Future<void> init() async {
    if (_initialized) return;
    await Future.wait([
      authSession.restoreSession(),
      locale.load(),
    ]);
    _initialized = true;
  }

  /// Token 失效时清本地登录态并提示（由 Dio 401 拦截触发）。
  void _handleUnauthorized() {
    if (_handlingUnauthorized) return;
    _handlingUnauthorized = true;
    authSession.forceLogout();
    AppMessenger.showInfo('登录已过期，请重新登录');
    _handlingUnauthorized = false;
  }
}
