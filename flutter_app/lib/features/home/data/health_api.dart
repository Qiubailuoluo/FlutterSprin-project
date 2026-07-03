import 'package:ledger/core/constants/api_constants.dart';
import 'package:ledger/core/di/app_services.dart';
import 'package:ledger/core/model/api_result.dart';
import 'package:ledger/core/network/dio_client.dart';

/// 健康检查 API，用于验证前后端连通。
class HealthApi {
  HealthApi({DioClient? client})
      : _client = client ?? AppServices.instance.dioClient;

  final DioClient _client;

  /// 调用 GET /api/health，返回 status 与 app 名称。
  Future<ApiResult<Map<String, String>>> check() {
    return _client.get(
      ApiConstants.healthPath,
      fromJsonT: (json) {
        if (json is Map) {
          return json.map((k, v) => MapEntry(k.toString(), v.toString()));
        }
        return null;
      },
    );
  }
}
