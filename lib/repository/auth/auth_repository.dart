import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../core/utils/error/auth_failure.dart';

abstract class AuthRepository {
  Future<Either<AuthFailure, void>> signInWithEmailAndPassword(
      {@required email, @required password});

  Future<Either<AuthFailure, void>> signUpWithEmailAndPassword(
      {@required email, @required password});

  Future<Either<AuthFailure, void>> signOut();
}
