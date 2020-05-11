import 'package:collectio/app/screen/collections/item_details/item_details.dart';
import 'package:collectio/model/collection_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  final CollectionItem item = CollectionItem(
    added: null,
    title: 'title',
    subtitle: 'subtitle',
    description: 'description',
    imageUrl: 'imageUrl',
    raiting: 10,
  );

  Widget makeTestableWidget() => MaterialApp(
        home: SingleChildScrollView(
          child: Container(
            height: 800,
            child: ItemDetailsScreen(item),
          ),
        ),
      );

  testWidgets(
    'should have an image and appropriate fields displayed',
    (WidgetTester tester) async {
      mockNetworkImagesFor(() async {
        await tester.pumpWidget(makeTestableWidget());

        final Finder imageFinder = find.byType(Image);
        final Finder titleFinder = find.text(item.title);
        final Finder subtitleFinder = find.text(item.subtitle);
        final Finder descriptionFinder = find.text(item.description);
        final Finder raitingFinder = find.text(item.raiting.toString());

        expect(imageFinder, findsOneWidget);
        expect(titleFinder, findsOneWidget);
        expect(subtitleFinder, findsOneWidget);
        expect(descriptionFinder, findsOneWidget);
        expect(raitingFinder, findsOneWidget);
      });
    },
  );
}
