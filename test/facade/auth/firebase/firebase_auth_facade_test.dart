import 'package:collectio/facade/auth/auth_facade.dart';
import 'package:collectio/facade/auth/firebase/firebase_auth_facade.dart';
import 'package:collectio/model/email.dart';
import 'package:collectio/model/password.dart';
import 'package:collectio/service/auth_service.dart';
import 'package:collectio/service/firebase/firebase_auth_service.dart';
import 'package:collectio/util/constant/constants.dart';
import 'package:collectio/util/error/auth_failure.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' as injectable;
import 'package:mockito/mockito.dart';

import '../../../mocks.dart';

void main() {
  configureInjection(injectable.Environment.test);

  final Email tEmail = Email('test@stelynx.com');
  final Password tPassword = Password('testpwd');

  MockedFirebaseAuthService mockedFirebaseAuthService;
  FirebaseAuthFacade firebaseAuthFacade;

  setUp(() {
    mockedFirebaseAuthService = getIt<AuthService>();
    firebaseAuthFacade =
        FirebaseAuthFacade(authService: mockedFirebaseAuthService);
  });

  group('signInWithEmailAndPassword', () {
    test('should call FirebaseAuthService.signInWithEmailAndPassword',
        () async {
      when(mockedFirebaseAuthService.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => null);

      await firebaseAuthFacade.signInWithEmailAndPassword(
          email: tEmail, password: tPassword);

      verify(mockedFirebaseAuthService.signInWithEmailAndPassword(
              email: tEmail.get(), password: tPassword.get()))
          .called(1);
    });

    test('should return null on success', () async {
      when(mockedFirebaseAuthService.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => null);

      final Either<AuthFailure, void> result = await firebaseAuthFacade
          .signInWithEmailAndPassword(email: tEmail, password: tPassword);

      expect(result, equals(Right(null)));
    });

    test('should return InvalidCombinationFailure on if user not found',
        () async {
      when(mockedFirebaseAuthService.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenThrow(PlatformException(code: Constants.userNotFoundError));

      final Either<AuthFailure, void> result = await firebaseAuthFacade
          .signInWithEmailAndPassword(email: tEmail, password: tPassword);

      expect(
        result,
        equals(Left(InvalidCombinationFailure())),
      );
    });

    test('should return InvalidCombinationFailure on if wrong password',
        () async {
      when(mockedFirebaseAuthService.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenThrow(PlatformException(code: Constants.wrongPasswordError));

      final Either<AuthFailure, void> result = await firebaseAuthFacade
          .signInWithEmailAndPassword(email: tEmail, password: tPassword);

      expect(
        result,
        equals(Left(InvalidCombinationFailure())),
      );
    });

    test('should return InvalidCombinationFailure on server failure', () async {
      when(mockedFirebaseAuthService.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenThrow(PlatformException(code: ''));

      final Either<AuthFailure, void> result = await firebaseAuthFacade
          .signInWithEmailAndPassword(email: tEmail, password: tPassword);

      expect(
        result,
        equals(Left(ServerFailure())),
      );
    });
  });

  group('signOut', () {
    test('should call FirebaseAuthService.logout', () async {
      when(mockedFirebaseAuthService.logout()).thenAnswer((_) async => null);

      await firebaseAuthFacade.signOut();

      verify(mockedFirebaseAuthService.logout()).called(1);
    });

    test('should return null on successful logout', () async {
      when(mockedFirebaseAuthService.logout()).thenAnswer((_) async => null);

      final Either<AuthFailure, void> result =
          await firebaseAuthFacade.signOut();

      expect(result, Right(null));
    });

    test('should return SignOutFailure on unsuccessful logout', () async {
      when(mockedFirebaseAuthService.logout()).thenThrow(Exception());

      final Either<AuthFailure, void> result =
          await firebaseAuthFacade.signOut();

      expect(result, Left(SignOutFailure(message: 'Exception')));
    });
  });

  group('signUpWithEmailAndPassword', () {
    test('should call FirebaseAuthService.signUpWithEmailAndPassword',
        () async {
      when(mockedFirebaseAuthService.signUpWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => null);

      await firebaseAuthFacade.signUpWithEmailAndPassword(
          email: tEmail, password: tPassword);

      verify(mockedFirebaseAuthService.signUpWithEmailAndPassword(
              email: tEmail.get(), password: tPassword.get()))
          .called(1);
    });

    test('should return null on success', () async {
      when(mockedFirebaseAuthService.signUpWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => null);

      final Either<AuthFailure, void> result = await firebaseAuthFacade
          .signUpWithEmailAndPassword(email: tEmail, password: tPassword);

      expect(result, equals(Right(null)));
    });

    test('should return EmailAlreadyInUseFailure on FirebaseAuthService error',
        () async {
      when(mockedFirebaseAuthService.signUpWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenThrow(PlatformException(code: Constants.emailAlreadyInUseError));

      final Either<AuthFailure, void> result = await firebaseAuthFacade
          .signUpWithEmailAndPassword(email: tEmail, password: tPassword);

      expect(
        result,
        equals(Left(EmailAlreadyInUseFailure())),
      );
    });

    test('should return ServerFailure on FirebaseAuthService error', () async {
      when(mockedFirebaseAuthService.signUpWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenThrow(PlatformException(code: ''));

      final Either<AuthFailure, void> result = await firebaseAuthFacade
          .signUpWithEmailAndPassword(email: tEmail, password: tPassword);

      expect(
        result,
        equals(Left(ServerFailure())),
      );
    });
  });

  group('getCurrentUser', () {
    final String tUserUid = 'userUid';

    test('should return current user if logged in', () async {
      when(mockedFirebaseAuthService.getCurrentUser())
          .thenAnswer((_) async => MockedFirebaseUser(tUserUid));

      final String result = await firebaseAuthFacade.getCurrentUser();

      expect(result, equals(tUserUid));
    });
  });
}
