import 'package:ledger/core/network/dio_client.dart';
import 'package:ledger/core/storage/token_storage.dart';
import 'package:ledger/features/auth/application/auth_session.dart';
import 'package:ledger/features/auth/data/auth_api.dart';
import 'package:ledger/features/bill/data/bill_api.dart';
import 'package:ledger/features/category/data/category_api.dart';
import 'package:ledger/features/stats/data/stats_api.dart';
import 'package:go_router/go_router.dart';
import 'package:ledger/app/router/app_router.dart';

/// 全局服务容器。
class AppServices {
  AppServices._();

  static final AppServices instance = AppServices._();

  final TokenStorage tokenStorage = TokenStorage();
  late final DioClient dioClient = DioClient(tokenStorage);
  late final AuthApi authApi = AuthApi(client: dioClient);
  late final StatsApi statsApi = StatsApi(client: dioClient);
  late final CategoryApi categoryApi = CategoryApi(client: dioClient);
  late final BillApi billApi = BillApi(client: dioClient);
  late final AuthSession authSession = AuthSession(
    tokenStorage: tokenStorage,
    authApi: authApi,
  );
  late final GoRouter router = AppRouter.create(authSession);

  bool _initialized = false;

  /// 启动时恢复登录态。
  Future<void> init() async {
    if (_initialized) return;
    await authSession.restoreSession();
    _initialized = true;
  }
}
