import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledger/core/widgets/async_state_view.dart';

void main() {
  testWidgets('AsyncStateView shows loading indicator', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AsyncStateView(
            loading: true,
            child: Text('content'),
          ),
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('AsyncStateView shows error with retry', (tester) async {
    var retried = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AsyncStateView(
            loading: false,
            error: '加载失败',
            onRetry: () => retried = true,
            child: const Text('content'),
          ),
        ),
      ),
    );
    expect(find.text('加载失败'), findsOneWidget);
    await tester.tap(find.text('重试'));
    expect(retried, true);
  });

  testWidgets('AsyncStateView shows empty state', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AsyncStateView(
            loading: false,
            isEmpty: true,
            emptyMessage: '暂无数据',
            child: Text('content'),
          ),
        ),
      ),
    );
    expect(find.text('暂无数据'), findsOneWidget);
    expect(find.text('content'), findsNothing);
  });
}
