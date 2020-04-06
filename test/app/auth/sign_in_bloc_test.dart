import 'package:bloc_test/bloc_test.dart';
import 'package:collectio/app/bloc/auth/sign_in_bloc.dart';
import 'package:collectio/model/email.dart';
import 'package:collectio/model/password.dart';
import 'package:collectio/util/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks.dart';

void main() {
  final MockedFirebaseAuthFacade mockedFirebaseAuthFacade =
      MockedFirebaseAuthFacade();

  blocTest(
    'should change state.email on email change',
    build: () async => SignInBloc(authFacade: mockedFirebaseAuthFacade),
    act: (SignInBloc bloc) async =>
        bloc..add(EmailChangedSignInEvent(email: 'a')),
    expect: [
      GeneralSignInState(
        email: Email('a'),
        showErrorMessages: true,
        authFailure: null,
      ),
    ],
    verify: (_) async => verifyZeroInteractions(mockedFirebaseAuthFacade),
  );

  blocTest(
    'should change state.password on password change',
    build: () async => SignInBloc(authFacade: mockedFirebaseAuthFacade),
    act: (SignInBloc bloc) async =>
        bloc..add(PasswordChangedSignInEvent(password: 'a')),
    expect: [
      GeneralSignInState(
        password: Password('a'),
        showErrorMessages: true,
        authFailure: null,
      ),
    ],
    verify: (_) async => verifyZeroInteractions(mockedFirebaseAuthFacade),
  );

  blocTest(
    'should not change state when signing in with invalid email',
    build: () async => SignInBloc(authFacade: mockedFirebaseAuthFacade),
    act: (SignInBloc bloc) async => bloc
      ..add(PasswordChangedSignInEvent(password: 'a'))
      ..add(SignInWithEmailAndPasswordSignInEvent()),
    expect: [
      GeneralSignInState(
        password: Password('a'),
        showErrorMessages: true,
      )
    ],
  );

  blocTest(
    'should not change state when signing in with invalid password',
    build: () async => SignInBloc(authFacade: mockedFirebaseAuthFacade),
    act: (SignInBloc bloc) async => bloc
      ..add(EmailChangedSignInEvent(email: 'a@b.c'))
      ..add(SignInWithEmailAndPasswordSignInEvent()),
    expect: [
      GeneralSignInState(email: Email('a@b.c'), showErrorMessages: true),
    ],
  );

  blocTest(
    'should not change state when registering with invalid email',
    build: () async => SignInBloc(authFacade: mockedFirebaseAuthFacade),
    act: (SignInBloc bloc) async => bloc
      ..add(PasswordChangedSignInEvent(password: 'a'))
      ..add(RegisterWithEmailAndPasswordSignInEvent()),
    expect: [
      GeneralSignInState(
        password: Password('a'),
        showErrorMessages: true,
      )
    ],
  );

  blocTest(
    'should not change state when registering in with invalid password',
    build: () async => SignInBloc(authFacade: mockedFirebaseAuthFacade),
    act: (SignInBloc bloc) async => bloc
      ..add(EmailChangedSignInEvent(email: 'a@b.c'))
      ..add(RegisterWithEmailAndPasswordSignInEvent()),
    expect: [
      GeneralSignInState(email: Email('a@b.c'), showErrorMessages: true),
    ],
  );

  blocTest(
    'should have Left(AuthFailure) when signing in with validated but wrong credentials',
    build: () async {
      when(mockedFirebaseAuthFacade.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => Left(InvalidCombinationFailure()));
      return SignInBloc(authFacade: mockedFirebaseAuthFacade);
    },
    act: (SignInBloc bloc) async => bloc
      ..add(EmailChangedSignInEvent(email: 'a@b.c'))
      ..add(PasswordChangedSignInEvent(password: 'a'))
      ..add(SignInWithEmailAndPasswordSignInEvent()),
    expect: [
      GeneralSignInState(
        email: Email('a@b.c'),
        showErrorMessages: true,
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('a'),
        showErrorMessages: true,
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('a'),
        showErrorMessages: true,
        isSubmitting: true,
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('a'),
        showErrorMessages: true,
        isSubmitting: false,
        authFailure: Left(InvalidCombinationFailure()),
      ),
    ],
    verify: (_) async => verify(
            mockedFirebaseAuthFacade.signInWithEmailAndPassword(
                email: Email('a@b.c'), password: Password('a')))
        .called(1),
  );

  blocTest(
    'should have Right(null) when signing in with validated and correct credentials',
    build: () async {
      when(mockedFirebaseAuthFacade.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => Right(null));
      return SignInBloc(authFacade: mockedFirebaseAuthFacade);
    },
    act: (SignInBloc bloc) async => bloc
      ..add(EmailChangedSignInEvent(email: 'a@b.c'))
      ..add(PasswordChangedSignInEvent(password: 'a'))
      ..add(SignInWithEmailAndPasswordSignInEvent()),
    expect: [
      GeneralSignInState(
        email: Email('a@b.c'),
        showErrorMessages: true,
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('a'),
        showErrorMessages: true,
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('a'),
        showErrorMessages: true,
        isSubmitting: true,
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('a'),
        showErrorMessages: true,
        isSubmitting: false,
        authFailure: Right(null),
      ),
    ],
    verify: (_) async => verify(
            mockedFirebaseAuthFacade.signInWithEmailAndPassword(
                email: Email('a@b.c'), password: Password('a')))
        .called(1),
  );
}
