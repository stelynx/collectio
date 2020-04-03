import 'package:collectio/core/service/firebase/firebase_auth_service.dart';
import 'package:collectio/repository/auth/firebase/firebase_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';

class MockedFirebaseAuth extends Mock implements FirebaseAuth {}

class MockedFirebaseUser extends Mock implements FirebaseUser {
  final String _uid;

  MockedFirebaseUser(this._uid);

  @override
  String get uid => _uid;
}

class MockedFirebaseAuthService extends Mock implements FirebaseAuthService {}

class MockedFirebaseAuthRepository extends Mock
    implements FirebaseAuthRepository {}
