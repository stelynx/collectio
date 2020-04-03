import 'package:meta/meta.dart';

abstract class AuthService {
  Future signInWithEmailAndPassword(
      {@required String email, @required String password});

  Future signUpWithEmailAndPassword(
      {@required String email, @required String password});

  Future logout();
}
