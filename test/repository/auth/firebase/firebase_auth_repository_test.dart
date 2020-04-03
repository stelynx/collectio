import 'package:collectio/core/service/firebase/firebase_auth_service.dart';
import 'package:collectio/core/utils/error/auth_failure.dart';
import 'package:collectio/repository/auth/firebase/firebase_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  final String tEmail = 'test@stelynx.com';
  final String tPassword = 'testpwd';

  MockedFirebaseAuthService mockedFirebaseAuthService;
  FirebaseAuthRepository firebaseAuthRepository;

  setUp(() {
    mockedFirebaseAuthService = MockedFirebaseAuthService();
    firebaseAuthRepository =
        FirebaseAuthRepository(authService: mockedFirebaseAuthService);
  });

  group('signInWithEmailAndPassword', () {
    test('should call FirebaseAuthService.signInWithEmailAndPassword',
        () async {
      when(mockedFirebaseAuthService.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => null);

      await firebaseAuthRepository.signInWithEmailAndPassword(
          email: tEmail, password: tPassword);

      verify(mockedFirebaseAuthService.signInWithEmailAndPassword(
              email: tEmail, password: tPassword))
          .called(1);
      verifyNoMoreInteractions(mockedFirebaseAuthService);
    });

    test('should return null on success', () async {
      when(mockedFirebaseAuthService.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => null);

      final Either<AuthFailure, void> result = await firebaseAuthRepository
          .signInWithEmailAndPassword(email: tEmail, password: tPassword);

      expect(result, equals(Right(null)));
    });

    test('should return InvalidEmailFailure on invalid email', () async {
      when(mockedFirebaseAuthService.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => null);

      final Either<AuthFailure, void> result = await firebaseAuthRepository
          .signInWithEmailAndPassword(email: 'a', password: tPassword);

      expect(
        result,
        equals(Left(InvalidEmailFailure(email: 'a', message: 'Invalid email'))),
      );
    });

    test('should return InvalidPasswordFailure on invalid password', () async {
      when(mockedFirebaseAuthService.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => null);

      final Either<AuthFailure, void> result = await firebaseAuthRepository
          .signInWithEmailAndPassword(email: tEmail, password: '');

      expect(
        result,
        equals(Left(
            InvalidPasswordFailure(password: '', message: 'Invalid password'))),
      );
    });

    test('should return InvalidCombinationFailure on FirebaseAuthService error',
        () async {
      when(mockedFirebaseAuthService.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenThrow(Exception());

      final Either<AuthFailure, void> result = await firebaseAuthRepository
          .signInWithEmailAndPassword(email: tEmail, password: tPassword);

      expect(
        result,
        equals(Left(InvalidCombinationFailure(
            email: tEmail, password: tPassword, message: 'Exception'))),
      );
    });
  });

  group('signOut', () {
    test('should call FirebaseAuthService.logout', () async {
      when(mockedFirebaseAuthService.logout()).thenAnswer((_) async => null);

      await firebaseAuthRepository.signOut();

      verify(mockedFirebaseAuthService.logout()).called(1);
      verifyNoMoreInteractions(mockedFirebaseAuthService);
    });

    test('should return null on successful logout', () async {
      when(mockedFirebaseAuthService.logout()).thenAnswer((_) async => null);

      final Either<AuthFailure, void> result =
          await firebaseAuthRepository.signOut();

      expect(result, Right(null));
    });

    test('should return SignOutFailure on unsuccessful logout', () async {
      when(mockedFirebaseAuthService.logout()).thenThrow(Exception());

      final Either<AuthFailure, void> result =
          await firebaseAuthRepository.signOut();

      expect(result, Left(SignOutFailure(message: 'Exception')));
    });
  });

  group('signUpWithEmailAndPassword', () {
    test('should call FirebaseAuthService.signUpWithEmailAndPassword',
        () async {
      when(mockedFirebaseAuthService.signUpWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => null);

      await firebaseAuthRepository.signUpWithEmailAndPassword(
          email: tEmail, password: tPassword);

      verify(mockedFirebaseAuthService.signUpWithEmailAndPassword(
              email: tEmail, password: tPassword))
          .called(1);
      verifyNoMoreInteractions(mockedFirebaseAuthService);
    });

    test('should return null on success', () async {
      when(mockedFirebaseAuthService.signUpWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => null);

      final Either<AuthFailure, void> result = await firebaseAuthRepository
          .signUpWithEmailAndPassword(email: tEmail, password: tPassword);

      expect(result, equals(Right(null)));
    });

    test('should return InvalidEmailFailure on invalid email', () async {
      when(mockedFirebaseAuthService.signUpWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => null);

      final Either<AuthFailure, void> result = await firebaseAuthRepository
          .signUpWithEmailAndPassword(email: 'a', password: tPassword);

      expect(
        result,
        equals(Left(InvalidEmailFailure(email: 'a', message: 'Invalid email'))),
      );
    });

    test('should return InvalidPasswordFailure on invalid password', () async {
      when(mockedFirebaseAuthService.signUpWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => null);

      final Either<AuthFailure, void> result = await firebaseAuthRepository
          .signUpWithEmailAndPassword(email: tEmail, password: '');

      expect(
        result,
        equals(Left(
            InvalidPasswordFailure(password: '', message: 'Invalid password'))),
      );
    });

    test('should return SignUpFailure on FirebaseAuthService error', () async {
      when(mockedFirebaseAuthService.signUpWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenThrow(Exception());

      final Either<AuthFailure, void> result = await firebaseAuthRepository
          .signUpWithEmailAndPassword(email: tEmail, password: tPassword);

      expect(
        result,
        equals(Left(SignUpFailure(message: 'Exception'))),
      );
    });
  });
}

class MockedFirebaseAuthService extends Mock implements FirebaseAuthService {}
