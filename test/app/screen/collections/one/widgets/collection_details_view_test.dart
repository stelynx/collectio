import 'package:collectio/app/screen/collections/one/widgets/collection_details_view.dart';
import 'package:collectio/app/widgets/circular_network_image.dart';
import 'package:collectio/model/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Collection collection = Collection(
    id: 'title',
    owner: 'owner',
    title: 'title',
    subtitle: 'subtitle',
    description: 'description',
    thumbnail: null,
    numberOfItems: 10,
  );

  Widget makeTestableWidget() =>
      MaterialApp(home: CollectionDetailsView(collection));

  testWidgets(
    'should have a CircularNetworkImage',
    (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget());

      final Finder cniFinder = find.byType(CircularNetworkImage);
      expect(cniFinder, findsOneWidget);
    },
  );

  testWidgets(
    'should have a 4x2 Table with title, subtitle, description, and item count',
    (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget());

      final Finder tableFinder = find.byType(Table);
      expect(tableFinder, findsOneWidget);

      final Finder cellFinder = find.byType(TableCell);
      expect(cellFinder, findsNWidgets(8));

      final Finder titleFinder = find.text('title');
      final Finder subtitleFinder = find.text('subtitle');
      final Finder descriptionFinder = find.text('description');
      final Finder itemCountFinder = find.text('10');
      expect(titleFinder, findsOneWidget);
      expect(subtitleFinder, findsOneWidget);
      expect(descriptionFinder, findsOneWidget);
      expect(itemCountFinder, findsOneWidget);
    },
  );
}
