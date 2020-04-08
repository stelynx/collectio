import 'package:bloc_test/bloc_test.dart';
import 'package:collectio/app/bloc/auth/auth_bloc.dart';
import 'package:collectio/facade/auth/auth_facade.dart';
import 'package:collectio/facade/auth/firebase/firebase_auth_facade.dart';
import 'package:collectio/util/error/auth_failure.dart';
import 'package:collectio/util/injection/injection.dart';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

void main() {
  configureInjection(Environment.test);

  final String tUserUid = 'ascklasjdasodka';

  final MockedFirebaseAuthFacade mockedFirebaseAuthFacade = getIt<AuthFacade>();

  blocTest(
    'should emit AuthenticatedAuthState when logged in',
    build: () async {
      when(mockedFirebaseAuthFacade.getCurrentUser())
          .thenAnswer((_) async => tUserUid);
      return AuthBloc(authFacade: mockedFirebaseAuthFacade);
    },
    act: (AuthBloc bloc) async => bloc.add(CheckStatusAuthEvent()),
    expect: [AuthenticatedAuthState(userUid: tUserUid)],
  );

  blocTest(
    'should emit UnauthenticatedAuthState when not logged in',
    build: () async {
      when(mockedFirebaseAuthFacade.getCurrentUser())
          .thenAnswer((_) async => null);
      return AuthBloc(authFacade: mockedFirebaseAuthFacade);
    },
    act: (AuthBloc bloc) async => bloc.add(CheckStatusAuthEvent()),
    expect: [UnauthenticatedAuthState()],
  );

  blocTest(
    'should emit UnauthenticatedAuthState on successful sign out',
    build: () async {
      when(mockedFirebaseAuthFacade.signOut())
          .thenAnswer((_) async => Right(null));
      return AuthBloc(authFacade: mockedFirebaseAuthFacade);
    },
    act: (AuthBloc bloc) async => bloc.add(SignedOutAuthEvent()),
    expect: [UnauthenticatedAuthState()],
  );

  blocTest(
    'should emit current state on unsuccessful sign out',
    build: () async {
      when(mockedFirebaseAuthFacade.signOut())
          .thenAnswer((_) async => Left(SignOutFailure()));
      return AuthBloc(authFacade: mockedFirebaseAuthFacade);
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
