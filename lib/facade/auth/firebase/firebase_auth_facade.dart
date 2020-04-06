import 'package:collectio/util/constant/constants.dart';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../../../model/email.dart';
import '../../../model/password.dart';
import '../../../service/firebase/firebase_auth_service.dart';
import '../../../util/error/auth_failure.dart';
import '../auth_facade.dart';

class FirebaseAuthFacade extends AuthFacade {
  final FirebaseAuthService authService;

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
    } catch (e) {
      return Left(SignOutFailure(message: e.toString()));
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
}
