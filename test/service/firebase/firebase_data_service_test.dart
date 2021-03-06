import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collectio/model/collection.dart';
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

  group('getUserProfileByUsername', () {
    test(
      'should call Firestore.collection with correct collection and where clause',
      () async {
        when(firebaseDataService.firestore.collection(any))
            .thenReturn(mockedCollectionReference);
        when(mockedCollectionReference.where(any,
                isEqualTo: anyNamed('isEqualTo')))
            .thenReturn(MockedCollectionReference());

        await firebaseDataService.getUserProfileByUsername(username: username);

        verify(mockedCollectionReference.where(
          Constants.usernameField,
          isEqualTo: username,
        )).called(1);
      },
    );
  });

  group('getUserProfileByUserUid', () {
    test(
      'should call Firestore.collection with correct collection and where clause',
      () async {
        when(firebaseDataService.firestore.collection(any))
            .thenReturn(mockedCollectionReference);
        when(mockedCollectionReference.where(any,
                isEqualTo: anyNamed('isEqualTo')))
            .thenReturn(MockedCollectionReference());

        await firebaseDataService.getUserProfileByUserUid(userUid: userUid);

        verify(mockedCollectionReference.where(
          Constants.userUidField,
          isEqualTo: userUid,
        )).called(1);
      },
    );
  });

  group('addCollection', () {
    test('should call Firestore with correct collection, document id and data',
        () async {
      final Map<String, dynamic> collectionJson = Collection(
        id: 'collectionId',
        owner: 'owner',
        title: 'title',
        subtitle: 'subtitle',
        description: 'description',
        thumbnail: 'thumbnail',
      ).toJson();

      when(firebaseDataService.firestore.collection(any))
          .thenReturn(mockedCollectionReference);
      when(mockedCollectionReference.document(any))
          .thenReturn(mockedDocumentReference);
      when(mockedDocumentReference.setData(any)).thenAnswer((_) async => null);

      await firebaseDataService.addCollection(
        owner: collectionJson['owner'],
        id: collectionJson['id'],
        collection: collectionJson,
      );

      verify(mockedCollectionReference.document(collectionJson['id']))
          .called(1);
      verify(mockedDocumentReference.setData(collectionJson)).called(1);
    });
  });

  group('addItemToCollection', () {
    test('should call Firestore with correct collection and document',
        () async {
      final Map<String, dynamic> item = <String, dynamic>{
        'description': 'description',
        'title': 'title',
        'subtitle': 'subtitle',
        'image': 'imageUrl',
        'rating': 10,
        'added': Timestamp.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch),
      };
      when(firebaseDataService.firestore.collection(any))
          .thenReturn(mockedCollectionReference);
      when(mockedCollectionReference.add(any))
          .thenAnswer((_) async => mockedDocumentReference);

      await firebaseDataService.addItemToCollection(
          owner: 'owner', collectionName: 'collectionName', item: item);

      verify(mockedCollectionReference.add(item)).called(1);
    });
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

  group('updateUserProfile', () {
    test('should call setData on correct document', () async {
      final Map<String, dynamic> userProfileJson = UserProfile(
        email: 'email',
        userUid: userUid,
        username: username,
      ).toJson();

      when(firebaseDataService.firestore.collection(any))
          .thenReturn(mockedCollectionReference);
      when(mockedCollectionReference.document(any))
          .thenReturn(mockedDocumentReference);
      when(mockedDocumentReference.setData(any)).thenAnswer((_) async => null);

      await firebaseDataService.updateUserProfile(
          id: userUid, userProfile: userProfileJson);

      verify(mockedCollectionReference.document(userUid)).called(1);
      verify(mockedDocumentReference.setData(userProfileJson)).called(1);
    });
  });

  group('deleteCollection', () {
    test('should call delete on correct collection', () async {
      when(firebaseDataService.firestore.document(any))
          .thenReturn(mockedDocumentReference);
      when(mockedDocumentReference.delete()).thenAnswer((_) async => null);

      await firebaseDataService.deleteCollection(
          owner: 'owner', collectionName: 'collectionName');

      verify(firebaseDataService.firestore
              .document('owner_collection/collectionName'))
          .called(1);
      verify(mockedDocumentReference.delete()).called(1);
    });
  });

  group('deleteItemInCollection', () {
    test('should call delete on correct item', () async {
      when(firebaseDataService.firestore.document(any))
          .thenReturn(mockedDocumentReference);
      when(mockedDocumentReference.delete()).thenAnswer((_) async => null);

      await firebaseDataService.deleteItemInCollection(
          owner: 'owner', collectionName: 'collectionName', itemId: 'itemId');

      verify(firebaseDataService.firestore
              .document('owner_collection/collectionName/items/itemId'))
          .called(1);
      verify(mockedDocumentReference.delete()).called(1);
    });
  });
}
