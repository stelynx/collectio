import 'package:collectio/app/widgets/collectio_section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget(String text) =>
      MaterialApp(home: CollectioSectionTitle(text));

  testWidgets('should have a specified text', (WidgetTester tester) async {
    final String text = 'test text';
    await tester.pumpWidget(makeTestableWidget(text));

    final Finder textFinder = find.text(text);

    expect(textFinder, findsOneWidget);
  });
}
