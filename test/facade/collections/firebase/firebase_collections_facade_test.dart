import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collectio/facade/collections/firebase/firebase_collections_facade.dart';
import 'package:collectio/model/collection.dart';
import 'package:collectio/service/data_service.dart';
import 'package:collectio/util/error/data_failure.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;
import 'package:mockito/mockito.dart';

import '../../../mocks.dart';

void main() {
  configureInjection(Environment.test);

  final String username = 'username';

  FirebaseCollectionsFacade firebaseCollectionsFacade;

  setUp(() {
    firebaseCollectionsFacade =
        FirebaseCollectionsFacade(dataService: getIt<DataService>());
  });

  group(('getCollectionsForUser'), () {
    test('should call FirebaseDataService with username', () async {
      when(firebaseCollectionsFacade.dataService.getCollectionsForUser(any))
          .thenAnswer((_) async => null);

      await firebaseCollectionsFacade.getCollectionsForUser(username);

      verify(firebaseCollectionsFacade.dataService
              .getCollectionsForUser(username))
          .called(1);
    });

    test('should return a list of collections on success', () async {
      when(firebaseCollectionsFacade.dataService.getCollectionsForUser(any))
          .thenAnswer(
        (_) async => MockedQuerySnapshot(
          List<DocumentSnapshot>()
            ..add(
              MockedDocumentSnapshot(
                'id',
                {
                  'owner': 'owner',
                  'title': 'title',
                  'subtitle': 'subtitle',
                  'thumbnail': 'thumbnail',
                  'description': 'description',
                },
              ),
            ),
        ),
      );

      final Either<DataFailure, List<Collection>> result =
          await firebaseCollectionsFacade.getCollectionsForUser(username);

      expect(result, isA<Right>());

      final List<Collection> collections = result.getOrElse(null);
      expect(collections.length, equals(1));
      expect(
        collections[0],
        equals(
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
        ),
      );
    });

    test('should return a DataFailure on any error', () async {
      when(firebaseCollectionsFacade.dataService.getCollectionsForUser(any))
          .thenThrow(Exception());

      final Either<DataFailure, List<Collection>> result =
          await firebaseCollectionsFacade.getCollectionsForUser(username);

      expect(result, equals(Left(DataFailure())));
    });
  });

  group('addCollection', () {
    test(
        'should call FirebaseDataService with owner, id, and collection as JSON',
        () async {
      final Collection collection = Collection(
        id: 'title',
        owner: 'owner',
        title: 'title',
        subtitle: 'subtitle',
        description: 'description',
        thumbnail: 'thumbnail',
      );

      when(firebaseCollectionsFacade.dataService.addCollection(
              owner: anyNamed('owner'),
              id: anyNamed('id'),
              collection: anyNamed('collection')))
          .thenAnswer((_) async => null);

      await firebaseCollectionsFacade.addCollection(collection);

      verify(firebaseCollectionsFacade.dataService.addCollection(
              owner: collection.owner,
              id: collection.id,
              collection: collection.toJson()))
          .called(1);
    });

    test('should return Right(null) on success', () async {
      final Collection collection = Collection(
        id: 'title',
        owner: 'owner',
        title: 'title',
        subtitle: 'subtitle',
        description: 'description',
        thumbnail: 'thumbnail',
      );

      when(firebaseCollectionsFacade.dataService.addCollection(
              owner: anyNamed('owner'),
              id: anyNamed('id'),
              collection: anyNamed('collection')))
          .thenAnswer((_) async => null);

      final Either<DataFailure, void> result =
          await firebaseCollectionsFacade.addCollection(collection);

      expect(result, equals(Right(null)));
    });

    test('should return Left(DataFailure) on any error', () async {
      final Collection collection = Collection(
        id: 'title',
        owner: 'owner',
        title: 'title',
        subtitle: 'subtitle',
        description: 'description',
        thumbnail: 'thumbnail',
      );

      when(firebaseCollectionsFacade.dataService.addCollection(
              owner: anyNamed('owner'),
              id: anyNamed('id'),
              collection: anyNamed('collection')))
          .thenThrow(Exception());

      final Either<DataFailure, void> result =
          await firebaseCollectionsFacade.addCollection(collection);

      expect(result, equals(Left(DataFailure())));
    });
  });
}
