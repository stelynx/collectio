import 'package:collectio/app/screen/shared/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('should have an error icon', (WidgetTester tester) async {
    Widget testWidget = new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(
        home: ErrorScreen(message: ''),
      ),
    );

    await tester.pumpWidget(testWidget);

    final Finder iconFinder = find.byIcon(Icons.error);

    expect(iconFinder, findsOneWidget);
  });

  testWidgets('should have an error message', (WidgetTester tester) async {
    final String errorMessage = 'Error message';
    Widget testWidget = new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(
        home: ErrorScreen(message: errorMessage),
      ),
    );

    await tester.pumpWidget(testWidget);

    final Finder messageFinder = find.text(errorMessage);

    expect(messageFinder, findsOneWidget);
  });
}
