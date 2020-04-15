import 'package:bloc_test/bloc_test.dart';
import 'package:collectio/app/bloc/collections/collections_bloc.dart';
import 'package:collectio/app/screen/collections/all/collections.dart';
import 'package:collectio/app/screen/shared/error.dart';
import 'package:collectio/app/widgets/collectio_list.dart';
import 'package:collectio/model/collection.dart';
import 'package:collectio/util/constant/constants.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;

void main() {
  configureInjection(Environment.test);

  CollectionsBloc collectionsBloc;

  Widget makeTestableWidget() {
    return MaterialApp(
      home: CollectionsScreen(),
    );
  }

  setUp(() {
    collectionsBloc = getIt<CollectionsBloc>();
  });

  testWidgets(
    'should show CircularProgressIndicator on Initial and Loading',
    (WidgetTester tester) async {
      final List<CollectionsState> states = [
        InitialCollectionsState(),
        LoadingCollectionsState(),
      ];
      whenListen(collectionsBloc, Stream.fromIterable(states));

      final Finder cipFinder = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(makeTestableWidget());
      await tester.pump();
      expect(cipFinder, findsOneWidget);
      await tester.pump();
      expect(cipFinder, findsOneWidget);
    },
  );

  testWidgets(
    'should show no items text on Loaded without items',
    (WidgetTester tester) async {
      final List<CollectionsState> states = [
        InitialCollectionsState(),
        LoadedCollectionsState(collections: <Collection>[]),
      ];
      whenListen(collectionsBloc, Stream.fromIterable(states));

      final Finder textFinder = find.text(Constants.noItems);

      await tester.pumpWidget(makeTestableWidget());
      await tester.pump();

      expect(textFinder, findsOneWidget);
    },
  );

  testWidgets(
    'should show ListView on Loaded with items',
    (WidgetTester tester) async {
      final List<CollectionsState> states = [
        InitialCollectionsState(),
        LoadedCollectionsState(
          collections: [
            Collection.fromJson(
              {
                'id': 'id',
                'owner': 'owner',
                'title': 'title',
                'subtitle': 'subtitle',
                'thumbnail': 'thumbnail',
                'description': 'description',
              },
            )
          ],
        ),
      ];
      whenListen(collectionsBloc, Stream.fromIterable(states));

      final Finder ltFinder = find.byType(ListTile);

      await tester.pumpWidget(makeTestableWidget());
      await tester.pump();

      expect(ltFinder, findsOneWidget);
    },
  );
}
