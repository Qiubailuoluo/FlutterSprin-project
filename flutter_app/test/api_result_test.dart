import 'package:flutter_test/flutter_test.dart';
import 'package:ledger/core/model/api_result.dart';

void main() {
  group('ApiResult.displayMessage', () {
    test('business failure uses message as-is', () {
      const result = ApiResult<void>(
        code: 403,
        message: '需要管理员权限',
      );
      expect(result.displayMessage, '需要管理员权限');
      expect(result.errorId, isNull);
    });

    test('500 with errorId shows fixed copy and id', () {
      const result = ApiResult<void>(
        code: 500,
        message: '服务器错误',
        errorId: 'deadbeef',
      );
      expect(result.displayMessage, '服务异常，请稍后重试（编号：deadbeef）');
      expect(result.displayMessage.contains('服务器错误'), isFalse);
      expect(result.displayMessage.contains('Exception'), isFalse);
    });

    test('500 without errorId shows fixed copy only', () {
      const result = ApiResult<void>(
        code: 500,
        message: '服务器错误',
      );
      expect(result.displayMessage, '服务异常，请稍后重试');
    });

    test('fromJson parses errorId', () {
      final result = ApiResult.fromJson(
        {
          'code': 500,
          'message': '服务器错误',
          'data': null,
          'errorId': 'aabbccdd',
        },
        (_) => null,
      );
      expect(result.isSuccess, isFalse);
      expect(result.errorId, 'aabbccdd');
      expect(result.displayMessage, contains('aabbccdd'));
    });

    test('empty business message falls back', () {
      const result = ApiResult<void>(code: 400, message: '');
      expect(result.displayMessage, '操作失败');
    });
  });
}
