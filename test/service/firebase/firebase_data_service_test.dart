import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collectio/model/user_profile.dart';
import 'package:collectio/service/firebase/firebase_data_service.dart';
import 'package:collectio/util/constant/constants.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;
import 'package:mockito/mockito.dart';

import '../../mocks.dart';

void main() {
  configureInjection(Environment.test);

  final String username = 'username';
  final String userUid = 'userUid';
  final MockedCollectionReference mockedCollectionReference =
      MockedCollectionReference();
  final MockedDocumentReference mockedDocumentReference =
      MockedDocumentReference();

  FirebaseDataService firebaseDataService;

  setUp(() {
    firebaseDataService = FirebaseDataService(firestore: getIt<Firestore>());
  });

  group('getCollectionsForUser', () {
    test('should call Firestore.collection with <username>_collection',
        () async {
      when(firebaseDataService.firestore.collection(any))
          .thenReturn(mockedCollectionReference);

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
          .thenReturn(mockedCollectionReference);

      await firebaseDataService.getItemsInCollection(
          username: username, collectionName: collectionName);

      verify(firebaseDataService.firestore
              .collection("${username}_collection/$collectionName/items"))
          .called(1);
    });
  });

  group('getUserProfile', () {
    test(
      'should call Firestore.collection with correct collection and where clause',
      () async {
        when(firebaseDataService.firestore.collection(any))
            .thenReturn(mockedCollectionReference);
        when(mockedCollectionReference.where(any,
                isEqualTo: anyNamed('isEqualTo')))
            .thenReturn(MockedCollectionReference());

        await firebaseDataService.getUserProfile(username: username);

        verify(mockedCollectionReference.where(
          Constants.usernameField,
          isEqualTo: username,
        )).called(1);
      },
    );
  });

  group('addUserProfile', () {
    test(
      'should call Firestore with correct collection, document and setData',
      () async {
        final Map<String, dynamic> userProfileJson = UserProfile(
          email: 'email',
          userUid: userUid,
          username: username,
        ).toJson();

        when(firebaseDataService.firestore.collection(any))
            .thenReturn(mockedCollectionReference);
        when(mockedCollectionReference.document(any))
            .thenReturn(mockedDocumentReference);
        when(mockedDocumentReference.setData(any))
            .thenAnswer((_) async => null);

        await firebaseDataService.addUserProfile(
            id: userProfileJson['username'], userProfile: userProfileJson);

        verify(mockedCollectionReference.document(userProfileJson['username']))
            .called(1);
        verify(mockedDocumentReference.setData(userProfileJson)).called(1);
      },
    );
  });
}
