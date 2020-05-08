import 'dart:io';

import 'package:collectio/service/firebase/firebase_storage_service.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;
import 'package:mockito/mockito.dart';

import '../../mocks.dart';

void main() {
  configureInjection(Environment.test);

  final String imageTitle = 'imageTitle';
  final String imageUrl = 'imageUrl';

  final File mockedFile = MockedFile();
  final FirebaseStorage storage = getIt<FirebaseStorage>();

  FirebaseStorageService storageService;
  StorageReference mockedStorageReference;

  setUp(() {
    storageService = FirebaseStorageService(storage: storage);
    mockedStorageReference = MockedStorageReference();
  });

  group('uploadCollectionThumbnail', () {
    test(
      'should call child and putFile on FirebaseStorage with correct arguments',
      () {
        when(storage.ref()).thenReturn(mockedStorageReference);
        when(mockedStorageReference.child(any))
            .thenReturn(mockedStorageReference);
        when(mockedStorageReference.putFile(any)).thenReturn(null);

        storageService.uploadCollectionThumbnail(
            image: mockedFile, destinationName: imageTitle);

        verify(mockedStorageReference.child('collectionThumbnail/$imageTitle'))
            .called(1);
        verify(mockedStorageReference.putFile(mockedFile)).called(1);
      },
    );
  });

  group('uploadItemImage', () {
    test(
      'should call child and putFile on FirebaseStorage with correct arguments',
      () {
        when(storage.ref()).thenReturn(mockedStorageReference);
        when(mockedStorageReference.child(any))
            .thenReturn(mockedStorageReference);
        when(mockedStorageReference.putFile(any)).thenReturn(null);

        storageService.uploadItemImage(
            image: mockedFile, destinationName: imageTitle);

        verify(mockedStorageReference.child('collectionItemImg/$imageTitle'))
            .called(1);
        verify(mockedStorageReference.putFile(mockedFile)).called(1);
      },
    );
  });

  group('getItemImageUrl', () {
    test(
      'should call getDownloadURL',
      () async {
        when(storage.ref()).thenReturn(mockedStorageReference);
        when(mockedStorageReference.child(any))
            .thenReturn(mockedStorageReference);

        await storageService.getItemImageUrl(imageName: imageTitle);

        verify(mockedStorageReference.child('collectionItemImg/$imageTitle'))
            .called(1);
        verify(mockedStorageReference.getDownloadURL()).called(1);
      },
    );

    test('should return appropriate download URL', () async {
      when(storage.ref()).thenReturn(mockedStorageReference);
      when(mockedStorageReference.child(any))
          .thenReturn(mockedStorageReference);
      when(mockedStorageReference.getDownloadURL())
          .thenAnswer((_) async => imageUrl);

      final String result =
          await storageService.getItemImageUrl(imageName: imageTitle);

      expect(result, equals(imageUrl));
    });
  });

  group('getCollectionThumbnailUrl', () {
    test(
      'should call getDownloadURL',
      () async {
        when(storage.ref()).thenReturn(mockedStorageReference);
        when(mockedStorageReference.child(any))
            .thenReturn(mockedStorageReference);

        await storageService.getCollectionThumbnailUrl(imageName: imageTitle);

        verify(mockedStorageReference.child('collectionThumbnail/$imageTitle'))
            .called(1);
        verify(mockedStorageReference.getDownloadURL()).called(1);
      },
    );

    test('should return appropriate download URL', () async {
      when(storage.ref()).thenReturn(mockedStorageReference);
      when(mockedStorageReference.child(any))
          .thenReturn(mockedStorageReference);
      when(mockedStorageReference.getDownloadURL())
          .thenAnswer((_) async => imageUrl);

      final String result =
          await storageService.getCollectionThumbnailUrl(imageName: imageTitle);

      expect(result, equals(imageUrl));
    });
  });
}
