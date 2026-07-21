import 'package:ledger/core/constants/api_constants.dart';
import 'package:ledger/core/di/app_services.dart';
import 'package:ledger/core/model/api_result.dart';
import 'package:ledger/core/network/dio_client.dart';
import 'package:ledger/features/stats/data/models/chart_stats.dart';
import 'package:ledger/features/stats/data/models/month_stats.dart';

/// 统计 API：月度汇总 + 图表。
class StatsApi {
  StatsApi({DioClient? client})
      : _client = client ?? AppServices.instance.dioClient;

  final DioClient _client;

  Future<ApiResult<MonthStats>> getMonthStats({int? year, int? month}) {
    return _client.get(
      ApiConstants.statsMonthPath,
      queryParameters: {
        'year': ?year,
        'month': ?month,
      },
      fromJsonT: (json) => MonthStats.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResult<List<CategoryShareItem>>> getCategoryShare({
    int? year,
    int? month,
  }) {
    return _client.get(
      ApiConstants.statsCategorySharePath,
      queryParameters: {
        'year': ?year,
        'month': ?month,
      },
      fromJsonT: (json) => (json as List<dynamic>)
          .map((e) => CategoryShareItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResult<List<TrendPoint>>> getTrend({int months = 6}) {
    return _client.get(
      ApiConstants.statsTrendPath,
      queryParameters: {'months': months},
      fromJsonT: (json) => (json as List<dynamic>)
          .map((e) => TrendPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResult<List<MemberStatItem>>> getByMember({
    int? year,
    int? month,
  }) {
    return _client.get(
      ApiConstants.statsByMemberPath,
      queryParameters: {
        'year': ?year,
        'month': ?month,
      },
      fromJsonT: (json) => (json as List<dynamic>)
          .map((e) => MemberStatItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
