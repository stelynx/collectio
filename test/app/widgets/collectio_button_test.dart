import 'package:collectio/app/widgets/collectio_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget(Widget child) => MaterialApp(
        home: CollectioButton(
          child: child,
          onPressed: null,
        ),
      );

  testWidgets('should have a Button with given child',
      (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(Text('child')));

    final Finder textFinder = find.byType(Text);

    expect(textFinder, findsOneWidget);
  });
}
