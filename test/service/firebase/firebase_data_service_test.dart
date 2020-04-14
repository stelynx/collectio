import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collectio/service/firebase/firebase_data_service.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;
import 'package:mockito/mockito.dart';

import '../../mocks.dart';

void main() {
  configureInjection(Environment.test);

  final String username = 'username';
  FirebaseDataService firebaseDataService;

  setUp(() {
    firebaseDataService = FirebaseDataService(firestore: getIt<Firestore>());
  });

  group('getCollectionsForUser', () {
    test('should call Firestore.collection with <username>_collection',
        () async {
      when(firebaseDataService.firestore.collection(any))
          .thenReturn(MockedCollectionReference());

      await firebaseDataService.getCollectionsForUser(username);

      verify(firebaseDataService.firestore.collection("${username}_collection"))
          .called(1);
    });
  });

  group('getItemsInCollection', () {
    test(
        'should call Firestore.collection with <username>_collection/<collection_name>/items',
        () async {
      final String collectionName = 'collectionName';
      when(firebaseDataService.firestore.collection(any))
          .thenReturn(MockedCollectionReference());

      await firebaseDataService.getItemsInCollection(
          username: username, collectionName: collectionName);

      verify(firebaseDataService.firestore
              .collection("${username}_collection/$collectionName/items"))
          .called(1);
    });
  });
}
