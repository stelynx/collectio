import 'package:collectio/core/service/firebase/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  final String _tEmail = 'test@stelynx.com';
  final String _tPassword = 'testpwd';

  final FirebaseAuth _mockedFirebaseAuth = MockedFirebaseAuth();
  FirebaseAuthService _firebaseAuthService;

  setUp(() {
    _firebaseAuthService =
        FirebaseAuthService(firebaseAuth: _mockedFirebaseAuth);
  });

  group('signInWithEmailAndPassword', () {
    test('should forward call to FirebaseAuth', () async {
      when(_mockedFirebaseAuth.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => null);

      await _firebaseAuthService.signInWithEmailAndPassword(
          email: _tEmail, password: _tPassword);

      verify(_mockedFirebaseAuth.signInWithEmailAndPassword(
              email: _tEmail, password: _tPassword))
          .called(1);
      verifyNoMoreInteractions(_mockedFirebaseAuth);
    });
  });

  group('signUpWithEmailAndPassword', () {
    test('should forward call to FirebaseAuth', () async {
      when(_mockedFirebaseAuth.createUserWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => null);

      await _firebaseAuthService.signUpWithEmailAndPassword(
          email: _tEmail, password: _tPassword);

      verify(_mockedFirebaseAuth.createUserWithEmailAndPassword(
              email: _tEmail, password: _tPassword))
          .called(1);
      verifyNoMoreInteractions(_mockedFirebaseAuth);
    });
  });

  group('logout', () {
    test('should forward call to FirebaseAuth', () async {
      when(_mockedFirebaseAuth.signOut()).thenAnswer((_) async => null);

      await _firebaseAuthService.logout();

      verify(_mockedFirebaseAuth.signOut()).called(1);
      verifyNoMoreInteractions(_mockedFirebaseAuth);
    });
  });
}

class MockedFirebaseAuth extends Mock implements FirebaseAuth {}
