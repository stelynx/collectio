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
          .collection("${username}_collection/$collectionName/items")
          .getDocuments();

  @override
  Future<QuerySnapshot> getUserProfile({@required String username}) =>
      _firestore
          .collection(Constants.userCollection)
          .where(Constants.usernameField, isEqualTo: username)
          .getDocuments();

  @override
  Future<void> addUserProfile({
    @required String id,
    @required Map<String, dynamic> userProfile,
  }) =>
      _firestore
          .collection(Constants.userCollection)
          .document(id)
          .setData(userProfile);
}

@test
@lazySingleton
@RegisterAs(DataService)
class MockedFirebaseDataService extends Mock implements DataService {}
