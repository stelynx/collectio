import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

@registerModule
abstract class InjectableFirebaseModule {
  @prod
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @prod
  @lazySingleton
  Firestore get firestore => Firestore.instance;

  @test
  @lazySingleton
  FirebaseAuth get mockedFirebaseAuth => MockedFirebaseAuth();

  @test
  @lazySingleton
  Firestore get mockedFirestore => MockedFirestore();
}

class MockedFirebaseAuth extends Mock implements FirebaseAuth {}

class MockedFirestore extends Mock implements Firestore {}
