import 'package:bloc_test/bloc_test.dart';
import 'package:collectio/app/auth/auth_bloc.dart';
import 'package:collectio/core/utils/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.dart';

void main() {
  final String tUserUid = 'ascklasjdasodka';

  final MockedFirebaseAuthRepository mockedFirebaseAuthRepository =
      MockedFirebaseAuthRepository();

  blocTest(
    'should emit AuthenticatedAuthState when logged in',
    build: () async {
      when(mockedFirebaseAuthRepository.getCurrentUser())
          .thenAnswer((_) async => tUserUid);
      return AuthBloc(authRepository: mockedFirebaseAuthRepository);
    },
    act: (AuthBloc bloc) async => bloc.add(CheckStatusAuthEvent()),
    expect: [AuthenticatedAuthState(userUid: tUserUid)],
  );

  blocTest(
    'should emit UnauthenticatedAuthState when not logged in',
    build: () async {
      when(mockedFirebaseAuthRepository.getCurrentUser())
          .thenAnswer((_) async => null);
      return AuthBloc(authRepository: mockedFirebaseAuthRepository);
    },
    act: (AuthBloc bloc) async => bloc.add(CheckStatusAuthEvent()),
    expect: [UnauthenticatedAuthState()],
  );

  blocTest(
    'should emit UnauthenticatedAuthState on successful sign out',
    build: () async {
      when(mockedFirebaseAuthRepository.signOut())
          .thenAnswer((_) async => Right(null));
      return AuthBloc(authRepository: mockedFirebaseAuthRepository);
    },
    act: (AuthBloc bloc) async => bloc.add(SignedOutAuthEvent()),
    expect: [UnauthenticatedAuthState()],
  );

  blocTest(
    'should emit current state on unsuccessful sign out',
    build: () async {
      when(mockedFirebaseAuthRepository.signOut())
          .thenAnswer((_) async => Left(SignOutFailure()));
      return AuthBloc(authRepository: mockedFirebaseAuthRepository);
    },
    act: (AuthBloc bloc) async {
      bloc.add(CheckStatusAuthEvent());
      bloc.add(SignedOutAuthEvent());
    },
    expect: [
      UnauthenticatedAuthState(),
    ], // We expect only one state to be here.
  );
}
