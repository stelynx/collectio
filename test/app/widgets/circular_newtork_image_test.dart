import 'package:collectio/app/widgets/circular_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget(String url) =>
      MaterialApp(home: CircularNetworkImage(url));
  testWidgets('should have a CircleAvatar', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget(null));

    final Finder caFinder = find.byType(CircleAvatar);

    expect(caFinder, findsOneWidget);
  });
}
