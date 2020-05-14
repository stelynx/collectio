import 'package:collectio/app/widgets/failure_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget(String text) =>
      MaterialApp(home: FailureText(text));

  testWidgets('should have a text', (WidgetTester tester) async {
    final String text = 'Test text';

    await tester.pumpWidget(makeTestableWidget(text));

    final Finder textFinder = find.text(text);
    expect(textFinder, findsOneWidget);
  });
}
