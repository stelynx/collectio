import 'package:collectio/app/widgets/collectio_drawer.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart';

void main() {
  configureInjection(Environment.prod);

  Widget makeTestableWidget() => MaterialApp(home: CollectioDrawer());

  testWidgets('should have a drawer', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget());

    final Finder drawerFinder = find.byType(Drawer);

    expect(drawerFinder, findsOneWidget);
  });

  testWidgets('should have a logout button', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget());

    final Finder logoutFinder = find.byIcon(Icons.exit_to_app);

    expect(logoutFinder, findsOneWidget);
  });
}
