import 'package:collectio/facade/auth/firebase/firebase_auth_facade.dart';
import 'package:collectio/service/firebase/firebase_auth_service.dart';
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

class MockedFirebaseAuthFacade extends Mock implements FirebaseAuthFacade {}
