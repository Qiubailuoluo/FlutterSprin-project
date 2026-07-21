import 'package:ledger/core/constants/api_constants.dart';
import 'package:ledger/core/di/app_services.dart';
import 'package:ledger/core/model/api_result.dart';
import 'package:ledger/core/network/dio_client.dart';
import 'package:ledger/features/admin/data/models/admin_user_item.dart';

/// 管理员账户管理 API，见 docs/api/admin-users.md。
class AdminUserApi {
  AdminUserApi({DioClient? client})
      : _client = client ?? AppServices.instance.dioClient;

  final DioClient _client;

  Future<ApiResult<List<AdminUserItem>>> list() {
    return _client.get(
      ApiConstants.adminUsersPath,
      fromJsonT: (json) => (json as List<dynamic>)
          .map((e) => AdminUserItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResult<AdminUserItem>> updateStatus({
    required int id,
    required int status,
  }) {
    return _client.put(
      '${ApiConstants.adminUsersPath}/$id/status',
      data: {'status': status},
      fromJsonT: (json) =>
          AdminUserItem.fromJson(json as Map<String, dynamic>),
    );
  }
}
