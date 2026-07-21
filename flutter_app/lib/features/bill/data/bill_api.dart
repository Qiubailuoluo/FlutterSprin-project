import 'package:ledger/core/constants/api_constants.dart';
import 'package:ledger/core/di/app_services.dart';
import 'package:ledger/core/model/api_result.dart';
import 'package:ledger/core/network/dio_client.dart';
import 'package:ledger/features/bill/data/models/bill_item.dart';
import 'package:ledger/features/bill/data/models/bill_page.dart';

/// 账单 API：分页查询、增删改。
///
/// 字段与 docs/api/bill.md 保持一致。
class BillApi {
  BillApi({DioClient? client})
      : _client = client ?? AppServices.instance.dioClient;

  final DioClient _client;

  /// GET /api/bills
  Future<ApiResult<BillPage>> page({
    int page = 1,
    int size = 20,
    int? type,
    int? categoryId,
    String? startDate,
    String? endDate,
  }) {
    return _client.get(
      ApiConstants.billsPath,
      queryParameters: {
        'page': page,
        'size': size,
        'type': ?type,
        'categoryId': ?categoryId,
        'startDate': ?startDate,
        'endDate': ?endDate,
      },
      fromJsonT: (json) => BillPage.fromJson(json as Map<String, dynamic>),
    );
  }

  /// POST /api/bills
  Future<ApiResult<BillItem>> create({
    required int categoryId,
    required int type,
    required double amount,
    required String billDate,
    String? remark,
    int? memberId,
  }) {
    return _client.post(
      ApiConstants.billsPath,
      data: {
        'categoryId': categoryId,
        'type': type,
        'amount': amount,
        'billDate': billDate,
        if (remark != null && remark.isNotEmpty) 'remark': remark,
        if (memberId != null) 'memberId': memberId,
      },
      fromJsonT: (json) => BillItem.fromJson(json as Map<String, dynamic>),
    );
  }

  /// PUT /api/bills/{id}
  Future<ApiResult<BillItem>> update({
    required int id,
    int? categoryId,
    int? type,
    double? amount,
    String? billDate,
    String? remark,
    int? memberId,
  }) {
    return _client.put(
      '${ApiConstants.billsPath}/$id',
      data: {
        'categoryId': ?categoryId,
        'type': ?type,
        'amount': ?amount,
        'billDate': ?billDate,
        'remark': ?remark,
        'memberId': ?memberId,
      },
      fromJsonT: (json) => BillItem.fromJson(json as Map<String, dynamic>),
    );
  }

  /// DELETE /api/bills/{id}
  Future<ApiResult<Object?>> delete(int id) {
    return _client.delete(
      '${ApiConstants.billsPath}/$id',
      fromJsonT: (_) => null,
    );
  }
}
