import 'package:ledger/core/constants/api_constants.dart';
import 'package:ledger/core/di/app_services.dart';
import 'package:ledger/core/model/api_result.dart';
import 'package:ledger/core/network/dio_client.dart';
import 'package:ledger/features/stats/data/models/month_stats.dart';

/// 统计 API：月度汇总。
///
/// 字段与 docs/api/stats.md 保持一致。
class StatsApi {
  StatsApi({DioClient? client})
      : _client = client ?? AppServices.instance.dioClient;

  final DioClient _client;

  /// GET /api/stats/month
  ///
  /// [year]、[month] 不传时后端默认当前年月。
  Future<ApiResult<MonthStats>> getMonthStats({
    int? year,
    int? month,
  }) {
    return _client.get(
      ApiConstants.statsMonthPath,
      queryParameters: {
        'year': ?year,
        'month': ?month,
      },
      fromJsonT: (json) => MonthStats.fromJson(json as Map<String, dynamic>),
    );
  }
}
