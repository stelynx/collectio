import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collectio/service/firebase/firebase_settings_service.dart';
import 'package:collectio/util/constant/constants.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;
import 'package:mockito/mockito.dart';

import '../../mocks.dart';

void main() {
  configureInjection(Environment.test);

  final String username = 'username';
  final Map<String, dynamic> settings = {'theme': 'LIGHT'};

  final MockedCollectionReference mockedCollectionReference =
      MockedCollectionReference();
  final MockedDocumentReference mockedDocumentReference =
      MockedDocumentReference();
  final MockedDocumentSnapshot mockedDocumentSnapshot =
      MockedDocumentSnapshot(username, settings);

  final Firestore firestore = getIt<Firestore>();
  final FirebaseSettingsService firebaseSettingsService =
      FirebaseSettingsService(firestore: firestore);

  group('getSettingsForUser', () {
    test('should call correct Firestore collection and get correct document',
        () async {
      when(firestore.collection(any)).thenReturn(mockedCollectionReference);
      when(mockedCollectionReference.document(any))
          .thenReturn(mockedDocumentReference);
      when(mockedDocumentReference.get())
          .thenAnswer((_) async => mockedDocumentSnapshot);

      final Map<String, dynamic> result =
          await firebaseSettingsService.getSettingsForUser(username: username);

      verify(firestore.collection(Constants.settingsCollection)).called(1);
      verify(mockedCollectionReference.document(username)).called(1);
      verify(mockedDocumentReference.get()).called(1);

      expect(result, equals(settings));
    });
  });

  group('setSettingsForUser', () {
    test('should call correct Firestore collection and set correct document',
        () async {
      when(firestore.collection(any)).thenReturn(mockedCollectionReference);
      when(mockedCollectionReference.document(any))
          .thenReturn(mockedDocumentReference);
      when(mockedDocumentReference.setData(any)).thenAnswer((_) async => null);

      await firebaseSettingsService.setSettingsForUser(
        username: username,
        settings: settings,
      );

      verify(firestore.collection(Constants.settingsCollection)).called(1);
      verify(mockedCollectionReference.document(username)).called(1);
      verify(mockedDocumentReference.setData(settings)).called(1);
    });
  });
}
