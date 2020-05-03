import 'package:collectio/app/screen/collections/new_item/new_item.dart';
import 'package:collectio/app/screen/collections/new_item/widgets/new_item_form.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;

void main() {
  configureInjection(Environment.prod);

  Widget makeTestableWidget() => MaterialApp(
      home: NewItemScreen(owner: 'owner', collectionName: 'collectionName'));

  testWidgets(
    'should have a Scaffold with AppBar and NewItemForm in body',
    (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget());

      final Finder scaffoldFinder = find.byType(Scaffold);
      expect(scaffoldFinder, findsOneWidget);

      final Finder appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);

      final Finder nifFinder = find.byType(NewItemForm);
      expect(nifFinder, findsOneWidget);
    },
  );
}
