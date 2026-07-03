import 'package:ledger/core/constants/api_constants.dart';
import 'package:ledger/core/di/app_services.dart';
import 'package:ledger/core/model/api_result.dart';
import 'package:ledger/core/network/dio_client.dart';
import 'package:ledger/features/auth/data/models/login_response.dart';
import 'package:ledger/features/auth/data/models/user_profile.dart';

/// 认证 API：注册、登录、退出、用户资料。
///
/// 字段与 docs/api/auth.md 保持一致。
class AuthApi {
  AuthApi({DioClient? client})
      : _client = client ?? AppServices.instance.dioClient;

  final DioClient _client;

  /// POST /api/auth/login
  Future<ApiResult<LoginResponse>> login({
    required String username,
    required String password,
  }) {
    return _client.post(
      ApiConstants.loginPath,
      data: {'username': username, 'password': password},
      fromJsonT: (json) =>
          LoginResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  /// POST /api/auth/register
  Future<ApiResult<UserProfile>> register({
    required String username,
    required String password,
    String? nickname,
  }) {
    return _client.post(
      ApiConstants.registerPath,
      data: {
        'username': username,
        'password': password,
        if (nickname != null && nickname.isNotEmpty) 'nickname': nickname,
      },
      fromJsonT: (json) => UserProfile.fromJson(json as Map<String, dynamic>),
    );
  }

  /// POST /api/auth/logout
  Future<ApiResult<Object?>> logout() {
    return _client.post(
      ApiConstants.logoutPath,
      fromJsonT: (_) => null,
    );
  }

  /// GET /api/user/profile
  Future<ApiResult<UserProfile>> getProfile() {
    return _client.get(
      ApiConstants.profilePath,
      fromJsonT: (json) => UserProfile.fromJson(json as Map<String, dynamic>),
    );
  }
}
