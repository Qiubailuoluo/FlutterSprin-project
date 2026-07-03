import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ledger/app/app.dart';
import 'test_helpers.dart';

void main() {
  setUp(() async {
    await initWidgetTestServices();
  });

  testWidgets('登录页显示表单', (WidgetTester tester) async {
    await tester.pumpWidget(const LedgerApp());
    await tester.pumpAndSettle();

    expect(find.text('登录'), findsWidgets);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('没有账号？去注册'), findsOneWidget);
  });
}
