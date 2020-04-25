import 'package:collectio/app/screen/collections/new/new_collection_screen.dart';
import 'package:collectio/app/screen/collections/new/widget/new_collection_form.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;

void main() {
  configureInjection(Environment.prod);

  Widget makeTestableWidget() => MaterialApp(home: NewCollectionScreen());

  testWidgets(
    'should have a Scaffold with AppBar and NewCollectionForm in body',
    (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget());

      final Finder scaffoldFinder = find.byType(Scaffold);
      expect(scaffoldFinder, findsOneWidget);

      final Finder appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);

      final Finder ncFinder = find.byType(NewCollectionForm);
      expect(ncFinder, findsOneWidget);
    },
  );
}
