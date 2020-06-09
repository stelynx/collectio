import 'package:meta/meta.dart';

abstract class AuthService {
  /// Signs in user with [email] and [password].
  Future signInWithEmailAndPassword(
      {@required String email, @required String password});

  /// Signs up user with [email] and [password].
  Future signUpWithEmailAndPassword(
      {@required String email, @required String password});

  /// Logs user out.
  Future logout();

  /// Returns current user.
  Future getCurrentUser();

  /// Returns [true] if email is already in use, otherwise [false].
  Future<bool> emailExists(String email);
}
