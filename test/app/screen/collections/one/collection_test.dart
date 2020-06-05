import 'package:collectio/app/screen/collections/one/collection.dart';
import 'package:collectio/app/screen/collections/one/widgets/collection_details_view.dart';
import 'package:collectio/model/collection.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart';

void main() {
  configureInjection(Environment.prod);

  final Collection collection = Collection(
      id: 'title',
      owner: 'owner',
      title: 'title',
      subtitle: 'subtitle',
      description: 'description',
      thumbnail: null);

  Widget makeTestableWidget() =>
      MaterialApp(home: CollectionScreen(collection));

  testWidgets(
    'should have a Scaffold with AppBar with title and subtitle',
    (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget());

      final Finder scaffoldFinder = find.byType(Scaffold);
      expect(scaffoldFinder, findsOneWidget);

      final Finder appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);

      final Finder titleFinder = find.descendant(
        of: appBarFinder,
        matching: find.text(collection.title),
      );
      expect(titleFinder, findsOneWidget);

      final Finder subtitleFinder = find.descendant(
        of: appBarFinder,
        matching: find.text(collection.subtitle),
      );
      expect(subtitleFinder, findsOneWidget);
    },
  );

  testWidgets(
    'should have CollectionDetailsView in body',
    (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget());

      final Finder scaffoldFinder = find.byType(Scaffold);
      final Finder cdvFinder = find.descendant(
        of: scaffoldFinder,
        matching: find.byType(CollectionDetailsView),
      );
      expect(cdvFinder, findsOneWidget);
    },
  );

  testWidgets(
    'should have CircularProgressIndicator when items not loaded',
    (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget());

      final Finder cpiFinder = find.byType(CircularProgressIndicator);
      expect(cpiFinder, findsOneWidget);
    },
  );
}
