import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../core/service/firebase/firebase_auth_service.dart';
import '../../../core/utils/error/auth_failure.dart';
import '../../../core/utils/function/validator.dart';
import '../auth_repository.dart';

class FirebaseAuthRepository extends AuthRepository {
  final FirebaseAuthService authService;

  FirebaseAuthRepository({@required this.authService}) : super();

  @override
  Future<Either<AuthFailure, void>> signInWithEmailAndPassword({
    @required email,
    @required password,
  }) async {
    if (!isValidEmail(email))
      return Left(InvalidEmailFailure(email: email, message: 'Invalid email'));
    if (!isValidPassword(password))
      return Left(InvalidPasswordFailure(
          password: password, message: 'Invalid password'));

    try {
      await authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(null);
    } catch (e) {
      return Left(InvalidCombinationFailure(
          email: email, password: password, message: e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, void>> signOut() async {
    try {
      await authService.logout();
      return Right(null);
    } catch (e) {
      return Left(SignOutFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, void>> signUpWithEmailAndPassword({
    @required email,
    @required password,
  }) async {
    if (!isValidEmail(email))
      return Left(InvalidEmailFailure(email: email, message: 'Invalid email'));
    if (!isValidPassword(password))
      return Left(InvalidPasswordFailure(
          password: password, message: 'Invalid password'));

    try {
      await authService.signUpWithEmailAndPassword(
          email: email, password: password);
      return Right(null);
    } catch (e) {
      return Left(SignUpFailure(message: e.toString()));
    }
  }
}
