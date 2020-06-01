import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import '../../../model/collection.dart';
import '../../../model/collection_item.dart';
import '../../../service/data_service.dart';
import '../../../service/storage_service.dart';
import '../../../util/error/data_failure.dart';
import '../collections_facade.dart';

@prod
@lazySingleton
@RegisterAs(CollectionsFacade)
class FirebaseCollectionsFacade extends CollectionsFacade {
  final DataService _dataService;
  final StorageService _storageService;

  DataService get dataService => _dataService;
  StorageService get storageService => _storageService;

  FirebaseCollectionsFacade({
    @required DataService dataService,
    @required StorageService storageService,
  })  : _dataService = dataService,
        _storageService = storageService;

  @override
  Future<Either<DataFailure, List<Collection>>> getCollectionsForUser(
      String username) async {
    try {
      final QuerySnapshot querySnapshot =
          await _dataService.getCollectionsForUser(username);
      final List<Map<String, dynamic>> collectionJsons = querySnapshot.documents
          .map((DocumentSnapshot documentSnapshot) => documentSnapshot.data
            ..addAll({'id': documentSnapshot.documentID}))
          .toList();

      for (Map<String, dynamic> collectionJson in collectionJsons) {
        try {
          collectionJson['thumbnail'] =
              await _storageService.getCollectionThumbnailUrl(
                  imageName: collectionJson['thumbnail']);
        } catch (_) {
          collectionJson['thumbnail'] = null;
        }
      }

      final List<Collection> collections = collectionJsons
          .map((Map<String, dynamic> json) => Collection.fromJson(json))
          .toList();
      return Right(collections);
    } catch (_) {
      return Left(DataFailure());
    }
  }

  @override
  Future<Either<DataFailure, void>> addCollection(Collection collection) async {
    try {
      await _dataService.addCollection(
        owner: collection.owner,
        id: collection.id,
        collection: collection.toJson(),
      );
      return Right(null);
    } catch (_) {
      return Left(DataFailure());
    }
  }

  @override
  Future<Either<DataFailure, void>> deleteCollection(
      Collection collection) async {
    try {
      await _dataService.deleteCollection(
        owner: collection.owner,
        collectionName: collection.id,
      );
      return Right(null);
    } catch (_) {
      return Left(DataFailure());
    }
  }

  @override
  Future<Either<DataFailure, void>> deleteItemInCollection({
    @required CollectionItem collectionItem,
  }) async {
    try {
      await _dataService.deleteItemInCollection(
        owner: collectionItem.parent.owner,
        collectionName: collectionItem.parent.id,
        itemId: collectionItem.id,
      );
      return Right(null);
    } catch (_) {
      return Left(DataFailure());
    }
  }

  @override
  Future<Either<DataFailure, List<CollectionItem>>> getItemsInCollection(
    Collection collection,
  ) async {
    try {
      final QuerySnapshot items = await _dataService.getItemsInCollection(
          username: collection.owner, collectionName: collection.id);

      final List<CollectionItem> collectionItems = [];
      for (DocumentSnapshot document in items.documents) {
        Map<String, dynamic> json = document.data;
        json['added'] = (json['added'] as Timestamp).millisecondsSinceEpoch;
        json['id'] = document.reference.documentID;

        try {
          json['image'] =
              await _storageService.getItemImageUrl(imageName: json['image']);
        } catch (_) {
          json['image'] = null;
        }

        final CollectionItem item =
            CollectionItem.fromJson(json, parent: collection);

        collectionItems.add(item);
      }

      return Right(collectionItems);
    } catch (_) {
      return Left(DataFailure());
    }
  }

  @override
  Future<Either<DataFailure, void>> addItemToCollection({
    @required String owner,
    @required String collectionName,
    @required CollectionItem item,
  }) async {
    try {
      final Map<String, dynamic> itemJson = item.toJson();
      itemJson['added'] =
          Timestamp.fromMillisecondsSinceEpoch(itemJson['added']);

      await _dataService.addItemToCollection(
        owner: owner,
        collectionName: collectionName,
        item: itemJson,
      );

      return Right(null);
    } catch (_) {
      return Left(DataFailure());
    }
  }

  @override
  Future<Either<DataFailure, void>> uploadCollectionThumbnail({
    @required File image,
    @required String destinationName,
  }) async {
    try {
      final bool isSuccessful = await _storageService.uploadCollectionThumbnail(
          image: image, destinationName: destinationName);
      if (isSuccessful)
        return Right(null);
      else
        return Left(DataFailure());
    } catch (_) {
      return Left(DataFailure());
    }
  }

  @override
  Future<Either<DataFailure, void>> uploadCollectionItemImage({
    @required File image,
    @required String destinationName,
  }) async {
    try {
      final bool isSuccessful = await _storageService.uploadItemImage(
          image: image, destinationName: destinationName);
      if (isSuccessful)
        return Right(null);
      else
        return Left(DataFailure());
    } catch (_) {
      return Left(DataFailure());
    }
  }
}

@test
@lazySingleton
@RegisterAs(CollectionsFacade)
class MockedFirebaseCollectionsFacade extends Mock
    implements CollectionsFacade {}
