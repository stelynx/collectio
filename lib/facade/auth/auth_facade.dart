import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../model/value_object/email.dart';
import '../../model/value_object/password.dart';
import '../../service/auth_service.dart';
import '../../util/error/auth_failure.dart';

abstract class AuthFacade {
  AuthService authService;

  /// Signs user in with [email] and [password].
  Future<Either<AuthFailure, void>> signInWithEmailAndPassword(
      {@required Email email, @required Password password});

  /// Signs user up with [email] and [password].
  Future<Either<AuthFailure, void>> signUpWithEmailAndPassword(
      {@required Email email, @required Password password});

  /// Signs user out.
  Future<Either<AuthFailure, void>> signOut();

  /// Gets current user.
  Future<String> getCurrentUser();

  /// Returns [Right(null)] if username is not taken,
  /// but if it is taken, [Left(AuthFailure)] is returned.
  Future<Either<AuthFailure, void>> emailNotExists(Email email);
}
