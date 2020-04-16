import 'package:collectio/service/firebase/firebase_auth_service.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' as injectable;
import 'package:mockito/mockito.dart';

void main() {
  configureInjection(injectable.Environment.test);

  final String _tEmail = 'test@stelynx.com';
  final String _tPassword = 'testpwd';

  final FirebaseAuth mockedFirebaseAuth = getIt<FirebaseAuth>();
  FirebaseAuthService firebaseAuthService;

  setUp(() {
    firebaseAuthService = FirebaseAuthService(firebaseAuth: mockedFirebaseAuth);
  });

  group('signInWithEmailAndPassword', () {
    test('should forward call to FirebaseAuth', () async {
      when(mockedFirebaseAuth.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => null);

      await firebaseAuthService.signInWithEmailAndPassword(
          email: _tEmail, password: _tPassword);

      verify(mockedFirebaseAuth.signInWithEmailAndPassword(
              email: _tEmail, password: _tPassword))
          .called(1);
      verifyNoMoreInteractions(mockedFirebaseAuth);
    });
  });

  group('signUpWithEmailAndPassword', () {
    test('should forward call to FirebaseAuth', () async {
      when(mockedFirebaseAuth.createUserWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => null);

      await firebaseAuthService.signUpWithEmailAndPassword(
          email: _tEmail, password: _tPassword);

      verify(mockedFirebaseAuth.createUserWithEmailAndPassword(
              email: _tEmail, password: _tPassword))
          .called(1);
      verifyNoMoreInteractions(mockedFirebaseAuth);
    });
  });

  group('logout', () {
    test('should forward call to FirebaseAuth.signOut', () async {
      when(mockedFirebaseAuth.signOut()).thenAnswer((_) async => null);

      await firebaseAuthService.logout();

      verify(mockedFirebaseAuth.signOut()).called(1);
      verifyNoMoreInteractions(mockedFirebaseAuth);
    });
  });

  group('getCurrentUser', () {
    test('should forward call to FirebaseAuth.currentUser', () async {
      when(mockedFirebaseAuth.currentUser()).thenAnswer((_) async => null);

      await firebaseAuthService.getCurrentUser();

      verify(mockedFirebaseAuth.currentUser()).called(1);
      verifyNoMoreInteractions(mockedFirebaseAuth);
    });
  });

  group('emailExists', () {
    final String email = 'email';

    test('should call FirebaseAuth.fetchSignInMethodsForEmail', () async {
      when(mockedFirebaseAuth.fetchSignInMethodsForEmail(
              email: anyNamed('email')))
          .thenAnswer((_) async => []);

      await firebaseAuthService.emailExists(email);

      verify(mockedFirebaseAuth.fetchSignInMethodsForEmail(email: email))
          .called(1);
      verifyNoMoreInteractions(mockedFirebaseAuth);
    });

    test('should return true if sign in methods available', () async {
      when(mockedFirebaseAuth.fetchSignInMethodsForEmail(
              email: anyNamed('email')))
          .thenAnswer((_) async => ['a', 'b']);

      final bool result = await firebaseAuthService.emailExists(email);

      expect(result, isTrue);
    });

    test('should return false if no sign in methods', () async {
      when(mockedFirebaseAuth.fetchSignInMethodsForEmail(
              email: anyNamed('email')))
          .thenAnswer((_) async => []);

      final bool result = await firebaseAuthService.emailExists(email);

      expect(result, isFalse);
    });
  });
}
