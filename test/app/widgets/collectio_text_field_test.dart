import 'package:collectio/app/widgets/collectio_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget() => MaterialApp(
        home: Scaffold(
          body: Container(
            child: CollectioTextField(
              labelText: 'label',
              errorText: 'error',
              onChanged: null,
            ),
          ),
        ),
      );

  testWidgets('should have a text field', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget());

    final Finder tfFinder = find.byType(TextField);

    expect(tfFinder, findsOneWidget);
  });
}
