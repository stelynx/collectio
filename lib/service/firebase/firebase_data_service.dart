import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import '../../util/constant/constants.dart';
import '../data_service.dart';

@prod
@lazySingleton
@RegisterAs(DataService)
class FirebaseDataService extends DataService {
  final Firestore _firestore;

  Firestore get firestore => _firestore;

  FirebaseDataService({@required Firestore firestore}) : _firestore = firestore;

  @override
  Future<QuerySnapshot> getCollectionsForUser(String username) =>
      _firestore.collection("${username}_collection").getDocuments();

  @override
  Future<QuerySnapshot> getItemsInCollection({
    @required String username,
    @required String collectionName,
  }) =>
      _firestore
          .collection('${username}_collection/$collectionName/items')
          .getDocuments();

  @override
  Future<QuerySnapshot> getUserProfileByUsername({@required String username}) =>
      _firestore
          .collection(Constants.userCollection)
          .where(Constants.usernameField, isEqualTo: username)
          .getDocuments();

  @override
  Future<QuerySnapshot> getUserProfileByUserUid({@required String userUid}) =>
      _firestore
          .collection(Constants.userCollection)
          .where(Constants.userUidField, isEqualTo: userUid)
          .getDocuments();

  @override
  Future<void> addCollection({
    @required String owner,
    @required String id,
    @required Map<String, dynamic> collection,
  }) async {
    _firestore
        .collection('${owner}_collection')
        .document(id)
        .setData(collection);
  }

  @override
  Future<void> addItemToCollection({
    @required String owner,
    @required String collectionName,
    @required Map<String, dynamic> item,
  }) =>
      _firestore
          .collection('${owner}_collection/$collectionName/items')
          .add(item);

  @override
  Future<void> addUserProfile({
    @required String id,
    @required Map<String, dynamic> userProfile,
  }) =>
      _firestore
          .collection(Constants.userCollection)
          .document(id)
          .setData(userProfile);

  @override
  Future<void> updateUserProfile({
    @required String id,
    @required Map<String, dynamic> userProfile,
  }) =>
      _firestore
          .collection(Constants.userCollection)
          .document(id)
          .setData(userProfile);

  @override
  Future<void> deleteCollection({
    @required String owner,
    @required String collectionName,
  }) =>
      _firestore.document('${owner}_collection/$collectionName').delete();

  @override
  Future<void> deleteItemInCollection({
    @required String owner,
    @required String collectionName,
    @required String itemId,
  }) =>
      _firestore
          .document('${owner}_collection/$collectionName/items/$itemId')
          .delete();
}

@test
@lazySingleton
@RegisterAs(DataService)
class MockedFirebaseDataService extends Mock implements DataService {}
