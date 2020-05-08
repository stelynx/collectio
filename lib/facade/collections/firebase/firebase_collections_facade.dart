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
        collectionJson['thumbnail'] = await _storageService
            .getCollectionThumbnailUrl(imageName: collectionJson['thumbnail']);
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
  Future<Either<DataFailure, List<CollectionItem>>> getItemsInCollection(
    String owner,
    String collectionId,
  ) async {
    try {
      final QuerySnapshot items = await _dataService.getItemsInCollection(
          username: owner, collectionName: collectionId);

      final List<CollectionItem> collectionItems = [];
      for (DocumentSnapshot document in items.documents) {
        Map<String, dynamic> json = document.data;
        json['added'] = (json['added'] as Timestamp).millisecondsSinceEpoch;
        json['id'] = document.reference.documentID;
        json['image'] =
            await _storageService.getItemImageUrl(imageName: json['image']);
        collectionItems.add(CollectionItem.fromJson(json));
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
      _storageService.uploadCollectionThumbnail(
          image: image, destinationName: destinationName);
      return Right(null);
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
      _storageService.uploadItemImage(
          image: image, destinationName: destinationName);
      return Right(null);
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
