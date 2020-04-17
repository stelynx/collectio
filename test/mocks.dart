import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

class MockedStreamSubscription<T> extends Mock
    implements StreamSubscription<T> {}

class MockedFirebaseUser extends Mock implements FirebaseUser {
  final String _uid;

  MockedFirebaseUser(this._uid);

  @override
  String get uid => _uid;
}

class MockedCollectionReference extends Mock implements CollectionReference {}

class MockedQuerySnapshot extends Mock implements QuerySnapshot {
  final List<DocumentSnapshot> _documents;

  MockedQuerySnapshot(this._documents);

  List<DocumentSnapshot> get documents => _documents;
}

class MockedDocumentSnapshot extends Mock implements DocumentSnapshot {
  final Map<String, dynamic> _data;
  final String _documentID;

  MockedDocumentSnapshot(this._documentID, this._data);

  Map<String, dynamic> get data => _data;
  String get documentID => _documentID;
}

class MockedDocumentReference extends Mock implements DocumentReference {}
