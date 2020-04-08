import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

class MockedFirebaseUser extends Mock implements FirebaseUser {
  final String _uid;

  MockedFirebaseUser(this._uid);

  @override
  String get uid => _uid;
}
