import 'package:collectio/app/widgets/collectio_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget() => MaterialApp(
        home: Scaffold(
          body: CollectioLink(
            text: 'text',
            onTap: () {},
          ),
        ),
      );

  testWidgets('should have an InkWell', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget());

    final Finder inkWellFinder = find.byType(InkWell);
    expect(inkWellFinder, findsOneWidget);

    await tester.tap(inkWellFinder);
  });

  testWidgets('should have a given text', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget());

    final Finder textFinder = find.text('text');
    expect(textFinder, findsOneWidget);
  });
}
