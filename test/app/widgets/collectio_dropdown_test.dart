import 'package:collectio/app/widgets/collectio_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget() => MaterialApp(
        home: Scaffold(
          body: Container(
            child: CollectioDropdown(
                value: 1, items: <int>[1, 2, 3], hint: 'hint', onChanged: null),
          ),
        ),
      );

  testWidgets('should have a DropdownButton', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget());

    final Finder ddFinder = find.byType(DropdownButtonHideUnderline);

    expect(ddFinder, findsOneWidget);
  });
}
