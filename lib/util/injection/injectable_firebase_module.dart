import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

import '../constant/constants.dart';

@registerModule
abstract class InjectableFirebaseModule {
  @prod
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @prod
  @lazySingleton
  Firestore get firestore => Firestore.instance;

  @prod
  @lazySingleton
  FirebaseStorage get firebaseStorage =>
      FirebaseStorage(storageBucket: Constants.firebaseStorageBucket);

  @test
  @lazySingleton
  FirebaseAuth get mockedFirebaseAuth => MockedFirebaseAuth();

  @test
  @lazySingleton
  Firestore get mockedFirestore => MockedFirestore();

  @test
  @lazySingleton
  FirebaseStorage get mockedFirebaseStorage => MockedFirebaseStorage();
}

class MockedFirebaseAuth extends Mock implements FirebaseAuth {}

class MockedFirestore extends Mock implements Firestore {}

class MockedFirebaseStorage extends Mock implements FirebaseStorage {}
