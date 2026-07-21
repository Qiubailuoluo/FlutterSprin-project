import 'package:ledger/core/constants/api_constants.dart';
import 'package:ledger/core/di/app_services.dart';
import 'package:ledger/core/model/api_result.dart';
import 'package:ledger/core/network/dio_client.dart';
import 'package:ledger/features/member/data/models/member_item.dart';

/// 家庭成员 API。
class MemberApi {
  MemberApi({DioClient? client})
      : _client = client ?? AppServices.instance.dioClient;

  final DioClient _client;

  Future<ApiResult<List<MemberItem>>> list() {
    return _client.get(
      ApiConstants.membersPath,
      fromJsonT: (json) {
        final list = json as List<dynamic>;
        return list
            .map((e) => MemberItem.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<ApiResult<MemberItem>> create({required String name}) {
    return _client.post(
      ApiConstants.membersPath,
      data: {'name': name},
      fromJsonT: (json) => MemberItem.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResult<Object?>> delete({required int id}) {
    return _client.delete(
      '${ApiConstants.membersPath}/$id',
      fromJsonT: (_) => null,
    );
  }
}
