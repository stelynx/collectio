import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../model/collection.dart';
import '../../../service/firebase/firebase_data_service.dart';
import '../../../util/error/data_failure.dart';
import '../collections_facade.dart';

class FirebaseCollectionsFacade extends CollectionsFacade {
  final FirebaseDataService _dataService;

  FirebaseDataService get dataService => _dataService;

  FirebaseCollectionsFacade({@required FirebaseDataService dataService})
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
    } catch (e) {
      return Left(DataFailure());
    }
  }
}
