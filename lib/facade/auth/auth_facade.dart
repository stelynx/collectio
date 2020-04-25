import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../model/value_object/email.dart';
import '../../model/value_object/password.dart';
import '../../service/auth_service.dart';
import '../../util/error/auth_failure.dart';

abstract class AuthFacade {
  AuthService authService;

  Future<Either<AuthFailure, void>> signInWithEmailAndPassword(
      {@required Email email, @required Password password});

  Future<Either<AuthFailure, void>> signUpWithEmailAndPassword(
      {@required Email email, @required Password password});

  Future<Either<AuthFailure, void>> signOut();

  Future<String> getCurrentUser();

  Future<Either<AuthFailure, void>> emailNotExists(Email email);
}
