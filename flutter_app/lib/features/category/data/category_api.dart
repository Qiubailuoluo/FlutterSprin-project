import 'package:ledger/core/constants/api_constants.dart';
import 'package:ledger/core/di/app_services.dart';
import 'package:ledger/core/model/api_result.dart';
import 'package:ledger/core/network/dio_client.dart';
import 'package:ledger/features/category/data/models/category_item.dart';

/// 分类 API：列表、新增、删除。
///
/// 字段与 docs/api/category.md 保持一致。
class CategoryApi {
  CategoryApi({DioClient? client})
      : _client = client ?? AppServices.instance.dioClient;

  final DioClient _client;

  /// GET /api/categories
  ///
  /// [type] 可选：1 收入 / 2 支出，不传返回全部。
  Future<ApiResult<List<CategoryItem>>> list({int? type}) {
    return _client.get(
      ApiConstants.categoriesPath,
      queryParameters: {'type': ?type},
      fromJsonT: (json) => (json as List)
          .map((e) => CategoryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// POST /api/categories
  Future<ApiResult<CategoryItem>> create({
    required String name,
    required int type,
  }) {
    return _client.post(
      ApiConstants.categoriesPath,
      data: {'name': name, 'type': type},
      fromJsonT: (json) =>
          CategoryItem.fromJson(json as Map<String, dynamic>),
    );
  }

  /// DELETE /api/categories/{id}
  Future<ApiResult<Object?>> delete(int id) {
    return _client.delete(
      '${ApiConstants.categoriesPath}/$id',
      fromJsonT: (_) => null,
    );
  }
}
