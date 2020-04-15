import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import '../auth_service.dart';

@prod
@lazySingleton
@RegisterAs(AuthService)
class FirebaseAuthService extends AuthService {
  final FirebaseAuth firebaseAuth;

  FirebaseAuthService({@required this.firebaseAuth});

  @override
  Future<AuthResult> signInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) =>
      firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

  @override
  Future<AuthResult> signUpWithEmailAndPassword({
    @required String email,
    @required String password,
  }) =>
      firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

  @override
  Future<void> logout() => firebaseAuth.signOut();

  @override
  Future<FirebaseUser> getCurrentUser() => firebaseAuth.currentUser();
}

@test
@lazySingleton
@RegisterAs(AuthService)
class MockedFirebaseAuthService extends Mock implements AuthService {}
