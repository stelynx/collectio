import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

class MockedFirebaseUser extends Mock implements FirebaseUser {
  final String _uid;

  MockedFirebaseUser(this._uid);

  @override
  String get uid => _uid;
}

class MockedCollectionReference extends Mock implements CollectionReference {}

class MockedQuerySnapshot extends Mock implements QuerySnapshot {
  final Object _documents;

  MockedQuerySnapshot(this._documents);

  Object getDocuments() => _documents;
}
