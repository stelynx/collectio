import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collectio/facade/collections/firebase/firebase_collections_facade.dart';
import 'package:collectio/model/collection.dart';
import 'package:collectio/model/collection_item.dart';
import 'package:collectio/service/data_service.dart';
import 'package:collectio/service/storage_service.dart';
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
  final File mockedFile = MockedFile();

  FirebaseCollectionsFacade firebaseCollectionsFacade;

  setUp(() {
    firebaseCollectionsFacade = FirebaseCollectionsFacade(
      dataService: getIt<DataService>(),
      storageService: getIt<StorageService>(),
    );
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

    test('should call FirebaseStorageService to get images for collections',
        () async {
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
            )
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
      when(firebaseCollectionsFacade.storageService
              .getCollectionThumbnailUrl(imageName: anyNamed('imageName')))
          .thenAnswer((_) async => 'thumbnail');

      await firebaseCollectionsFacade.getCollectionsForUser(username);

      verify(firebaseCollectionsFacade.storageService
              .getCollectionThumbnailUrl(imageName: 'thumbnail'))
          .called(2);
    });

    test('should set thumbnails to null on failure', () async {
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
      when(firebaseCollectionsFacade.storageService
              .getCollectionThumbnailUrl(imageName: anyNamed('imageName')))
          .thenThrow(Exception());

      final Either<DataFailure, List<Collection>> result =
          await firebaseCollectionsFacade.getCollectionsForUser(username);

      expect(result.isRight(), isTrue);
      expect(result.getOrElse(null)[0].thumbnail, isNull);
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
      when(firebaseCollectionsFacade.storageService
              .getCollectionThumbnailUrl(imageName: anyNamed('imageName')))
          .thenAnswer((_) async => 'thumbnail');

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

  group('deleteCollection', () {
    final Collection collection = Collection(
      id: 'title',
      owner: 'owner',
      title: 'title',
      subtitle: 'subtitle',
      description: 'description',
      thumbnail: 'thumbnail',
    );

    test('should call DataService.deleteCollection', () async {
      when(firebaseCollectionsFacade.dataService.deleteCollection(
              owner: anyNamed('owner'),
              collectionName: anyNamed('collectionName')))
          .thenAnswer((_) async => null);

      await firebaseCollectionsFacade.deleteCollection(collection);

      verify(firebaseCollectionsFacade.dataService.deleteCollection(
              owner: collection.owner, collectionName: collection.id))
          .called(1);
    });

    test('should return Right(null) on success', () async {
      when(firebaseCollectionsFacade.dataService.deleteCollection(
              owner: anyNamed('owner'),
              collectionName: anyNamed('collectionName')))
          .thenAnswer((_) async => null);

      final Either<DataFailure, void> result =
          await firebaseCollectionsFacade.deleteCollection(collection);

      expect(result, equals(Right(null)));
    });

    test('should return Left(DataFailure) on any failure', () async {
      when(firebaseCollectionsFacade.dataService.deleteCollection(
              owner: anyNamed('owner'),
              collectionName: anyNamed('collectionName')))
          .thenThrow(Exception());

      final Either<DataFailure, void> result =
          await firebaseCollectionsFacade.deleteCollection(collection);

      expect(result, equals(Left(DataFailure())));
    });
  });

  group('deleteItemInCollection', () {
    final Collection collection = Collection(
      id: 'title',
      owner: 'owner',
      title: 'title',
      subtitle: 'subtitle',
      description: 'description',
      thumbnail: 'thumbnail',
    );
    final CollectionItem item = CollectionItem(
      id: 'id',
      parent: collection,
      added: null,
      title: 'title',
      subtitle: 'subtitle',
      description: 'description',
      imageUrl: 'imageUrl',
      raiting: 10,
    );

    test('should call DataService.deleteItemInCollection', () async {
      when(firebaseCollectionsFacade.dataService.deleteItemInCollection(
              owner: anyNamed('owner'),
              collectionName: anyNamed('collectionName'),
              itemId: 'id'))
          .thenAnswer((_) async => null);

      await firebaseCollectionsFacade.deleteItemInCollection(
          collectionItem: item);

      verify(firebaseCollectionsFacade.dataService.deleteItemInCollection(
        owner: item.parent.owner,
        collectionName: item.parent.id,
        itemId: item.id,
      )).called(1);
    });

    test('should return Right(null) on success', () async {
      when(firebaseCollectionsFacade.dataService.deleteItemInCollection(
              owner: anyNamed('owner'),
              collectionName: anyNamed('collectionName'),
              itemId: 'id'))
          .thenAnswer((_) async => null);

      final Either<DataFailure, void> result = await firebaseCollectionsFacade
          .deleteItemInCollection(collectionItem: item);

      expect(result, equals(Right(null)));
    });

    test('should return Left(DataFailure) on any failure', () async {
      when(firebaseCollectionsFacade.dataService.deleteItemInCollection(
              owner: anyNamed('owner'),
              collectionName: anyNamed('collectionName'),
              itemId: 'id'))
          .thenThrow(Exception());

      final Either<DataFailure, void> result = await firebaseCollectionsFacade
          .deleteItemInCollection(collectionItem: item);

      expect(result, equals(Left(DataFailure())));
    });
  });

  group('getItemsInCollection', () {
    final Collection collection = Collection(
      id: 'collectionId',
      owner: 'owner',
      title: 'collectionId',
      subtitle: 'subtitle',
      description: 'description',
      thumbnail: 'thumbnail',
    );

    test('should call FirebaseDataService.getItemsInCollection', () async {
      when(firebaseCollectionsFacade.dataService.getItemsInCollection(
              username: anyNamed('username'),
              collectionName: anyNamed('collectionName')))
          .thenAnswer((_) async => null);

      await firebaseCollectionsFacade.getItemsInCollection(collection);

      verify(firebaseCollectionsFacade.dataService.getItemsInCollection(
              username: 'owner', collectionName: 'collectionId'))
          .called(1);
    });

    test('should return Left(DataFailure) on any error', () async {
      when(firebaseCollectionsFacade.dataService.getItemsInCollection(
              username: anyNamed('username'),
              collectionName: anyNamed('collectionName')))
          .thenThrow(Exception());

      final Either<DataFailure, List<CollectionItem>> result =
          await firebaseCollectionsFacade.getItemsInCollection(collection);

      expect(result, equals(Left(DataFailure())));
    });

    test('should return Right(List<CollectionItem>) on success', () async {
      final Map<String, dynamic> firestoreCollectionItem = <String, dynamic>{
        'added': Timestamp.fromMillisecondsSinceEpoch(10000),
        'title': 'title',
        'subtitle': 'subtitle',
        'description': 'description',
        'image': 'imageUrl',
        'raiting': 10,
      };
      final CollectionItem collectionItem = CollectionItem(
        parent: collection,
        id: 'documentId',
        added: DateTime.fromMillisecondsSinceEpoch(10000),
        title: 'title',
        subtitle: 'subtitle',
        description: 'description',
        imageUrl: 'imageUrl',
        raiting: 10,
      );
      final MockedDocumentSnapshot documentSnapshot =
          MockedDocumentSnapshot('documentID', firestoreCollectionItem);
      final MockedDocumentReference documentReference =
          MockedDocumentReference();
      when(documentSnapshot.reference).thenReturn(documentReference);
      when(documentReference.documentID).thenReturn('documentId');
      when(firebaseCollectionsFacade.dataService.getItemsInCollection(
              username: anyNamed('username'),
              collectionName: anyNamed('collectionName')))
          .thenAnswer((_) async => MockedQuerySnapshot([documentSnapshot]));
      when(firebaseCollectionsFacade.storageService
              .getItemImageUrl(imageName: anyNamed('imageName')))
          .thenAnswer((_) async => 'imageUrl');

      final Either<DataFailure, List<CollectionItem>> result =
          await firebaseCollectionsFacade.getItemsInCollection(collection);

      expect(result.isRight(), isTrue);
      expect(result.getOrElse(null)[0], equals(collectionItem));
    });

    test('should set image URLs to null on failure', () async {
      final Map<String, dynamic> firestoreCollectionItem = <String, dynamic>{
        'added': Timestamp.fromMillisecondsSinceEpoch(10000),
        'title': 'title',
        'subtitle': 'subtitle',
        'description': 'description',
        'image': 'imageUrl',
        'raiting': 10,
      };
      final MockedDocumentSnapshot documentSnapshot =
          MockedDocumentSnapshot('documentID', firestoreCollectionItem);
      final MockedDocumentReference documentReference =
          MockedDocumentReference();
      when(documentSnapshot.reference).thenReturn(documentReference);
      when(documentReference.documentID).thenReturn('documentId');
      when(firebaseCollectionsFacade.dataService.getItemsInCollection(
              username: anyNamed('username'),
              collectionName: anyNamed('collectionName')))
          .thenAnswer((_) async => MockedQuerySnapshot([documentSnapshot]));
      when(firebaseCollectionsFacade.storageService
              .getItemImageUrl(imageName: anyNamed('imageName')))
          .thenThrow(Exception());

      final Either<DataFailure, List<CollectionItem>> result =
          await firebaseCollectionsFacade.getItemsInCollection(collection);

      expect(result.isRight(), isTrue);
      expect(result.getOrElse(null)[0].thumbnail, isNull);
    });
  });

  group('addItemToCollection', () {
    final CollectionItem item = CollectionItem(
      id: 'title',
      description: 'description',
      title: 'title',
      subtitle: 'subtitle',
      imageUrl: 'imageUrl',
      raiting: 10,
      added: DateTime.now(),
    );

    final Map<String, dynamic> itemJson = item.toJson();
    itemJson['added'] = Timestamp.fromMillisecondsSinceEpoch(itemJson['added']);

    test('should call FirebaseDataService', () async {
      when(firebaseCollectionsFacade.dataService.addItemToCollection(
        owner: anyNamed('owner'),
        collectionName: anyNamed('collectionName'),
        item: anyNamed('item'),
      )).thenAnswer((_) async => Right(null));

      await firebaseCollectionsFacade.addItemToCollection(
          owner: 'owner', collectionName: 'collectionName', item: item);

      verify(firebaseCollectionsFacade.dataService.addItemToCollection(
              owner: 'owner', collectionName: 'collectionName', item: itemJson))
          .called(1);
    });

    test('should return Right(null) on success', () async {
      when(firebaseCollectionsFacade.dataService.addItemToCollection(
        owner: anyNamed('owner'),
        collectionName: anyNamed('collectionName'),
        item: anyNamed('item'),
      )).thenAnswer((_) async => Right(null));

      final Either<DataFailure, void> result =
          await firebaseCollectionsFacade.addItemToCollection(
              owner: 'owner', collectionName: 'collectionName', item: item);

      expect(result, equals(Right(null)));
    });

    test('should return Left(DataFailure) on any failure', () async {
      when(firebaseCollectionsFacade.dataService.addItemToCollection(
        owner: anyNamed('owner'),
        collectionName: anyNamed('collectionName'),
        item: anyNamed('item'),
      )).thenThrow(Exception());

      final Either<DataFailure, void> result =
          await firebaseCollectionsFacade.addItemToCollection(
              owner: 'owner', collectionName: 'collectionName', item: item);

      expect(result, equals(Left(DataFailure())));
    });
  });

  group('uploadCollectionThumbnail', () {
    test('should call FirebaseStorageService with same arguments', () async {
      when(firebaseCollectionsFacade.storageService.uploadCollectionThumbnail(
              image: anyNamed('image'),
              destinationName: anyNamed('destinationName')))
          .thenAnswer((_) async => null);

      await firebaseCollectionsFacade.uploadCollectionThumbnail(
          image: mockedFile, destinationName: 'destinationName');

      verify(firebaseCollectionsFacade.storageService.uploadCollectionThumbnail(
              image: mockedFile, destinationName: 'destinationName'))
          .called(1);
    });

    test('should return Right(null) on successful upload', () async {
      when(firebaseCollectionsFacade.storageService.uploadCollectionThumbnail(
              image: anyNamed('image'),
              destinationName: anyNamed('destinationName')))
          .thenAnswer((_) async => true);

      final Either<DataFailure, void> result =
          await firebaseCollectionsFacade.uploadCollectionThumbnail(
              image: mockedFile, destinationName: 'destinationName');

      expect(result, equals(Right(null)));
    });

    test('should return Left(DataFailure) on failed upload', () async {
      when(firebaseCollectionsFacade.storageService.uploadCollectionThumbnail(
              image: anyNamed('image'),
              destinationName: anyNamed('destinationName')))
          .thenAnswer((_) async => false);

      final Either<DataFailure, void> result =
          await firebaseCollectionsFacade.uploadCollectionThumbnail(
              image: mockedFile, destinationName: 'destinationName');

      expect(result, equals(Left(DataFailure())));
    });

    test('should return Left(DataFailure) on any exception', () async {
      when(firebaseCollectionsFacade.storageService.uploadCollectionThumbnail(
              image: anyNamed('image'),
              destinationName: anyNamed('destinationName')))
          .thenThrow(Exception());

      final Either<DataFailure, void> result =
          await firebaseCollectionsFacade.uploadCollectionThumbnail(
              image: mockedFile, destinationName: 'destinationName');

      expect(result, equals(Left(DataFailure())));
    });
  });

  group('uploadCollectionItemImage', () {
    test('should call FirebaseStorageService with same arguments', () async {
      when(firebaseCollectionsFacade.storageService.uploadItemImage(
              image: anyNamed('image'),
              destinationName: anyNamed('destinationName')))
          .thenAnswer((_) async => null);

      await firebaseCollectionsFacade.uploadCollectionItemImage(
          image: mockedFile, destinationName: 'destinationName');

      verify(firebaseCollectionsFacade.storageService.uploadItemImage(
              image: mockedFile, destinationName: 'destinationName'))
          .called(1);
    });

    test('should return Right(null) on successful upload', () async {
      when(firebaseCollectionsFacade.storageService.uploadItemImage(
              image: anyNamed('image'),
              destinationName: anyNamed('destinationName')))
          .thenAnswer((_) async => true);

      final Either<DataFailure, void> result =
          await firebaseCollectionsFacade.uploadCollectionItemImage(
              image: mockedFile, destinationName: 'destinationName');

      expect(result, equals(Right(null)));
    });

    test('should return Left(DataFailure) on failed upload', () async {
      when(firebaseCollectionsFacade.storageService.uploadItemImage(
              image: anyNamed('image'),
              destinationName: anyNamed('destinationName')))
          .thenAnswer((_) async => false);

      final Either<DataFailure, void> result =
          await firebaseCollectionsFacade.uploadCollectionItemImage(
              image: mockedFile, destinationName: 'destinationName');

      expect(result, equals(Left(DataFailure())));
    });

    test('should return Left(DataFailure) on any exception', () async {
      when(firebaseCollectionsFacade.storageService.uploadItemImage(
              image: anyNamed('image'),
              destinationName: anyNamed('destinationName')))
          .thenThrow(Exception());

      final Either<DataFailure, void> result =
          await firebaseCollectionsFacade.uploadCollectionItemImage(
              image: mockedFile, destinationName: 'destinationName');

      expect(result, equals(Left(DataFailure())));
    });
  });
}
