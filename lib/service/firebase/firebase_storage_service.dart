import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import '../storage_service.dart';

@prod
@lazySingleton
@RegisterAs(StorageService)
class FirebaseStorageService extends StorageService {
  FirebaseStorage _storage;

  FirebaseStorageService({@required FirebaseStorage storage})
      : _storage = storage;

  Future<bool> uploadCollectionThumbnail(
      {@required File image, @required String destinationName}) async {
    final String storagePath = 'collectionThumbnail/$destinationName';
    final StorageUploadTask storageUploadTask =
        _storage.ref().child(storagePath).putFile(image);

    await storageUploadTask.onComplete;

    return storageUploadTask.isSuccessful;
  }

  @override
  Future<bool> uploadItemImage(
      {@required File image, @required String destinationName}) async {
    final String storagePath = 'collectionItemImg/$destinationName';
    final StorageUploadTask storageUploadTask =
        _storage.ref().child(storagePath).putFile(image);
    await storageUploadTask.onComplete;

    return storageUploadTask.isSuccessful;
  }

  @override
  Future<String> getCollectionThumbnailUrl({@required String imageName}) async {
    final String storagePath = 'collectionThumbnail/$imageName';
    return (await _storage.ref().child(storagePath).getDownloadURL()) as String;
  }

  @override
  Future<String> getItemImageUrl({@required String imageName}) async {
    final String storagePath = 'collectionItemImg/$imageName';
    return (await _storage.ref().child(storagePath).getDownloadURL()) as String;
  }
}

@test
@lazySingleton
@RegisterAs(StorageService)
class MockedFirebaseStorageService extends Mock
    implements FirebaseStorageService {}
