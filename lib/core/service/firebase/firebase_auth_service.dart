import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../auth_service.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth firebaseAuth;

  const FirebaseAuthService({@required this.firebaseAuth});

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
}
