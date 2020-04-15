import 'package:collectio/app/widgets/collectio_list.dart';
import 'package:collectio/model/collection.dart';
import 'package:collectio/model/interface/listable.dart';
import 'package:collectio/util/constant/constants.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart';

void main() {
  configureInjection(Environment.test);

  Widget makeTestableWidget(
      List<Listable> items, void Function(Listable) onTap) {
    return MaterialApp(
      home: Scaffold(
        body: CollectioList(
          items: items,
          onTap: onTap,
        ),
      ),
    );
  }

  testWidgets(
    'should find a warning message on no items',
    (WidgetTester tester) async {
      final Finder iconFinder = find.byType(Icon);
      final Finder textFinder = find.text(Constants.noItems);

      await tester.pumpWidget(makeTestableWidget([], (_) {}));

      expect(iconFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
    },
  );

  testWidgets(
    'should find a ListView and n ListTiles',
    (WidgetTester tester) async {
      final List<Collection> collections = [
        Collection.fromJson(
          {
            'id': 'id',
            'owner': 'owner',
            'title': 'title',
            'subtitle': 'subtitle',
            'thumbnail': 'thumbnail',
            'description': 'description',
          },
        ),
        Collection.fromJson(
          {
            'id': 'id',
            'owner': 'owner',
            'title': 'title',
            'subtitle': 'subtitle',
            'thumbnail': 'thumbnail',
            'description': 'description',
          },
        ),
        Collection.fromJson(
          {
            'id': 'id',
            'owner': 'owner',
            'title': 'title',
            'subtitle': 'subtitle',
            'thumbnail': 'thumbnail',
            'description': 'description',
          },
        ),
      ];

      final Finder lvFinder = find.byType(ListView);
      final Finder ltFinder = find.byType(ListTile);
      final Finder titleFinder = find.text('title');
      final Finder subtitleFinder = find.text('subtitle');
      final Finder iconFinder = find.byIcon(Icons.chevron_right);

      await tester.pumpWidget(makeTestableWidget(collections, (_) {}));

      expect(lvFinder, findsOneWidget);
      expect(ltFinder, findsNWidgets(collections.length));
      expect(titleFinder, findsNWidgets(collections.length));
      expect(subtitleFinder, findsNWidgets(collections.length));
      expect(iconFinder, findsNWidgets(collections.length));
    },
  );
}
