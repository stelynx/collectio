import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import '../../../model/value_object/email.dart';
import '../../../model/value_object/password.dart';
import '../../../service/auth_service.dart';
import '../../../util/constant/constants.dart';
import '../../../util/error/auth_failure.dart';
import '../auth_facade.dart';

@prod
@lazySingleton
@RegisterAs(AuthFacade)
class FirebaseAuthFacade extends AuthFacade {
  final AuthService authService;

  FirebaseAuthFacade({@required this.authService}) : super();

  @override
  Future<Either<AuthFailure, void>> signInWithEmailAndPassword({
    @required Email email,
    @required Password password,
  }) async {
    final String emailString = email.get();
    final String passwordString = password.get();

    try {
      await authService.signInWithEmailAndPassword(
        email: emailString,
        password: passwordString,
      );
      return Right(null);
    } on PlatformException catch (e) {
      if (e.code == Constants.userNotFoundError ||
          e.code == Constants.wrongPasswordError)
        return Left(InvalidCombinationFailure());
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<AuthFailure, void>> signOut() async {
    try {
      await authService.logout();
      return Right(null);
    } catch (_) {
      return Left(SignOutFailure());
    }
  }

  @override
  Future<Either<AuthFailure, void>> signUpWithEmailAndPassword({
    @required Email email,
    @required Password password,
  }) async {
    final String emailString = email.get();
    final String passwordString = password.get();

    try {
      await authService.signUpWithEmailAndPassword(
          email: emailString, password: passwordString);
      return Right(null);
    } on PlatformException catch (e) {
      if (e.code == Constants.emailAlreadyInUseError)
        return Left(EmailAlreadyInUseFailure());
      return Left(ServerFailure());
    }
  }

  @override
  Future<String> getCurrentUser() async {
    final FirebaseUser user = await authService.getCurrentUser();
    return user != null ? user.uid : null;
  }

  @override
  Future<Either<AuthFailure, void>> emailNotExists(Email email) async {
    try {
      final bool doesEmailExist = await authService.emailExists(email.get());
      return doesEmailExist ? Left(EmailAlreadyInUseFailure()) : Right(null);
    } on PlatformException catch (_) {
      return Left(ServerFailure());
    }
  }
}

@test
@lazySingleton
@RegisterAs(AuthFacade)
class MockedFirebaseAuthFacade extends Mock implements AuthFacade {}
