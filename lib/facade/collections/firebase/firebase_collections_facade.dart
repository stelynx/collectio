import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import '../../../model/collection.dart';
import '../../../model/collection_item.dart';
import '../../../service/data_service.dart';
import '../../../util/error/data_failure.dart';
import '../collections_facade.dart';

@prod
@lazySingleton
@RegisterAs(CollectionsFacade)
class FirebaseCollectionsFacade extends CollectionsFacade {
  final DataService _dataService;

  DataService get dataService => _dataService;

  FirebaseCollectionsFacade({@required DataService dataService})
      : _dataService = dataService;

  @override
  Future<Either<DataFailure, List<Collection>>> getCollectionsForUser(
      String username) async {
    try {
      final QuerySnapshot querySnapshot =
          await _dataService.getCollectionsForUser(username);
      final List<Collection> collections = querySnapshot.documents
          .map((DocumentSnapshot documentSnapshot) => documentSnapshot.data
            ..addAll({'id': documentSnapshot.documentID}))
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
      items.documents.forEach((DocumentSnapshot document) {
        Map<String, dynamic> json = document.data;
        json['added'] = (json['added'] as Timestamp).millisecondsSinceEpoch;
        json['id'] = document.reference.documentID;
        collectionItems.add(CollectionItem.fromJson(json));
      });

      return Right(collectionItems);
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
