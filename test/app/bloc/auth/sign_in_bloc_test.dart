import 'package:bloc_test/bloc_test.dart';
import 'package:collectio/app/bloc/auth/sign_in_bloc.dart';
import 'package:collectio/facade/auth/auth_facade.dart';
import 'package:collectio/facade/auth/firebase/firebase_auth_facade.dart';
import 'package:collectio/facade/profile/firebase/firebase_profile_facade.dart';
import 'package:collectio/facade/profile/profile_facade.dart';
import 'package:collectio/model/email.dart';
import 'package:collectio/model/password.dart';
import 'package:collectio/model/username.dart';
import 'package:collectio/util/constant/constants.dart';
import 'package:collectio/util/error/data_failure.dart';
import 'package:collectio/util/error/failure.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

void main() {
  configureInjection(Environment.test);

  final MockedFirebaseAuthFacade mockedFirebaseAuthFacade = getIt<AuthFacade>();
  final MockedFirebaseProfileFacade mockedFirebaseProfileFacade =
      getIt<ProfileFacade>();

  blocTest(
    'should change state.email on email change',
    build: () async => SignInBloc(
      authFacade: mockedFirebaseAuthFacade,
      profileFacade: mockedFirebaseProfileFacade,
    ),
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
    build: () async => SignInBloc(
      authFacade: mockedFirebaseAuthFacade,
      profileFacade: mockedFirebaseProfileFacade,
    ),
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
    'should change state.username on username change',
    build: () async => SignInBloc(
      authFacade: mockedFirebaseAuthFacade,
      profileFacade: mockedFirebaseProfileFacade,
    ),
    act: (SignInBloc bloc) async =>
        bloc..add(UsernameChangedSignInEvent(username: 'a')),
    expect: [
      GeneralSignInState(
        username: Username('a'),
        showErrorMessages: true,
        authFailure: null,
      ),
    ],
  );

  blocTest(
    'should not change state when signing in with invalid email',
    build: () async => SignInBloc(
      authFacade: mockedFirebaseAuthFacade,
      profileFacade: mockedFirebaseProfileFacade,
    ),
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
    build: () async => SignInBloc(
        authFacade: mockedFirebaseAuthFacade,
        profileFacade: mockedFirebaseProfileFacade),
    act: (SignInBloc bloc) async => bloc
      ..add(EmailChangedSignInEvent(email: 'a@b.c'))
      ..add(SignInWithEmailAndPasswordSignInEvent()),
    expect: [
      GeneralSignInState(email: Email('a@b.c'), showErrorMessages: true),
    ],
  );

  blocTest(
    'should not change state when registering with invalid email',
    build: () async => SignInBloc(
      authFacade: mockedFirebaseAuthFacade,
      profileFacade: mockedFirebaseProfileFacade,
    ),
    act: (SignInBloc bloc) async => bloc
      ..add(PasswordChangedSignInEvent(password: 'a'))
      ..add(UsernameChangedSignInEvent(username: 'aasd'))
      ..add(RegisterWithEmailAndPasswordSignInEvent()),
    expect: [
      GeneralSignInState(
        password: Password('a'),
        showErrorMessages: true,
      ),
      GeneralSignInState(
        password: Password('a'),
        username: Username('aasd'),
        showErrorMessages: true,
      )
    ],
  );

  blocTest(
    'should not change state when registering with invalid password',
    build: () async => SignInBloc(
      authFacade: mockedFirebaseAuthFacade,
      profileFacade: mockedFirebaseProfileFacade,
    ),
    act: (SignInBloc bloc) async => bloc
      ..add(EmailChangedSignInEvent(email: 'a@b.c'))
      ..add(UsernameChangedSignInEvent(username: 'aasd'))
      ..add(RegisterWithEmailAndPasswordSignInEvent()),
    expect: [
      GeneralSignInState(email: Email('a@b.c'), showErrorMessages: true),
      GeneralSignInState(
        email: Email('a@b.c'),
        username: Username('aasd'),
        showErrorMessages: true,
      ),
    ],
  );

  blocTest(
    'should not change state when registering with invalid username',
    build: () async => SignInBloc(
      authFacade: mockedFirebaseAuthFacade,
      profileFacade: mockedFirebaseProfileFacade,
    ),
    act: (SignInBloc bloc) async => bloc
      ..add(EmailChangedSignInEvent(email: 'a@b.c'))
      ..add(PasswordChangedSignInEvent(password: 'a'))
      ..add(RegisterWithEmailAndPasswordSignInEvent()),
    expect: [
      GeneralSignInState(email: Email('a@b.c'), showErrorMessages: true),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('a'),
        showErrorMessages: true,
      ),
    ],
  );

  blocTest(
    'should have Left(AuthFailure) when signing in with validated but wrong credentials',
    build: () async {
      when(mockedFirebaseAuthFacade.signInWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => Left(InvalidCombinationFailure()));
      return SignInBloc(
        authFacade: mockedFirebaseAuthFacade,
        profileFacade: mockedFirebaseProfileFacade,
      );
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
      return SignInBloc(
        authFacade: mockedFirebaseAuthFacade,
        profileFacade: mockedFirebaseProfileFacade,
      );
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

  blocTest(
    'should not change state when checking for existing email with invalid email',
    build: () async => SignInBloc(
      authFacade: mockedFirebaseAuthFacade,
      profileFacade: mockedFirebaseProfileFacade,
    ),
    act: (SignInBloc bloc) async => bloc
      ..add(PasswordChangedSignInEvent(password: 'a'))
      ..add(CheckIfEmailExistsSignInEvent()),
    expect: [
      GeneralSignInState(
        password: Password('a'),
        showErrorMessages: true,
      )
    ],
  );

  blocTest(
    'should not change state when checking for existing email with invalid password',
    build: () async => SignInBloc(
        authFacade: mockedFirebaseAuthFacade,
        profileFacade: mockedFirebaseProfileFacade),
    act: (SignInBloc bloc) async => bloc
      ..add(EmailChangedSignInEvent(email: 'a@b.c'))
      ..add(CheckIfEmailExistsSignInEvent()),
    expect: [
      GeneralSignInState(email: Email('a@b.c'), showErrorMessages: true),
    ],
  );

  blocTest(
    'should have state.authFailure Right(null) on check for email exists and no email was present',
    build: () async {
      when(mockedFirebaseAuthFacade.emailNotExists(any))
          .thenAnswer((_) async => Right(null));
      return SignInBloc(
        authFacade: mockedFirebaseAuthFacade,
        profileFacade: mockedFirebaseProfileFacade,
      );
    },
    act: (SignInBloc bloc) async => bloc
      ..add(EmailChangedSignInEvent(email: 'a@b.c'))
      ..add(PasswordChangedSignInEvent(password: 'a'))
      ..add(CheckIfEmailExistsSignInEvent()),
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
        isSubmitting: true,
        showErrorMessages: true,
        isRegistering: true,
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('a'),
        isSubmitting: false,
        showErrorMessages: true,
        isRegistering: true,
        authFailure: Right(null),
      ),
    ],
  );

  blocTest(
    'should be able to register when username not in use',
    build: () async {
      when(mockedFirebaseProfileFacade.getUserProfile(username: 'username'))
          .thenAnswer((_) async =>
              Left(DataFailure(message: Constants.notExactlyOneObjectFound)));
      when(mockedFirebaseAuthFacade.signUpWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => Right(null));
      return SignInBloc(
        authFacade: mockedFirebaseAuthFacade,
        profileFacade: mockedFirebaseProfileFacade,
      );
    },
    act: (SignInBloc bloc) async => bloc
      ..add(EmailChangedSignInEvent(email: 'a@b.c'))
      ..add(PasswordChangedSignInEvent(password: 'a'))
      ..add(UsernameChangedSignInEvent(username: 'username'))
      ..add(RegisterWithEmailAndPasswordSignInEvent()),
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
        username: Username('username'),
        showErrorMessages: true,
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('a'),
        username: Username('username'),
        isSubmitting: true,
        showErrorMessages: true,
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('a'),
        username: Username('username'),
        isSubmitting: false,
        showErrorMessages: true,
        authFailure: Right(null),
      ),
    ],
  );

  blocTest(
    'should not be able to register when username is in use',
    build: () async {
      when(mockedFirebaseProfileFacade.getUserProfile(username: 'username'))
          .thenAnswer((_) async => Right(null));
      return SignInBloc(
        authFacade: mockedFirebaseAuthFacade,
        profileFacade: mockedFirebaseProfileFacade,
      );
    },
    act: (SignInBloc bloc) async => bloc
      ..add(EmailChangedSignInEvent(email: 'a@b.com'))
      ..add(PasswordChangedSignInEvent(password: 'a'))
      ..add(UsernameChangedSignInEvent(username: 'username'))
      ..add(RegisterWithEmailAndPasswordSignInEvent()),
    expect: [
      GeneralSignInState(
        email: Email('a@b.com'),
        showErrorMessages: true,
      ),
      GeneralSignInState(
        email: Email('a@b.com'),
        password: Password('a'),
        showErrorMessages: true,
      ),
      GeneralSignInState(
        email: Email('a@b.com'),
        password: Password('a'),
        username: Username('username'),
        showErrorMessages: true,
      ),
      GeneralSignInState(
        email: Email('a@b.com'),
        password: Password('a'),
        username: Username('username'),
        isRegistering: true,
        showErrorMessages: true,
        authFailure: Left(UsernameAlreadyInUseFailure()),
      ),
    ],
    verify: (_) async => verifyNever(
        mockedFirebaseAuthFacade.signUpWithEmailAndPassword(
            email: Email('a@b.com'), password: Password('a'))),
  );

  blocTest(
    'should not be able to register when failed to check for username',
    build: () async {
      when(mockedFirebaseProfileFacade.getUserProfile(username: 'username'))
          .thenAnswer((_) async => Left(DataFailure()));
      return SignInBloc(
        authFacade: mockedFirebaseAuthFacade,
        profileFacade: mockedFirebaseProfileFacade,
      );
    },
    act: (SignInBloc bloc) async => bloc
      ..add(EmailChangedSignInEvent(email: 'a@b.comm'))
      ..add(PasswordChangedSignInEvent(password: 'a'))
      ..add(UsernameChangedSignInEvent(username: 'username'))
      ..add(RegisterWithEmailAndPasswordSignInEvent()),
    expect: [
      GeneralSignInState(
        email: Email('a@b.comm'),
        showErrorMessages: true,
      ),
      GeneralSignInState(
        email: Email('a@b.comm'),
        password: Password('a'),
        showErrorMessages: true,
      ),
      GeneralSignInState(
        email: Email('a@b.comm'),
        password: Password('a'),
        username: Username('username'),
        showErrorMessages: true,
      ),
      GeneralSignInState(
        email: Email('a@b.comm'),
        password: Password('a'),
        username: Username('username'),
        isRegistering: true,
        showErrorMessages: true,
        authFailure: Left(ServerFailure()),
      ),
    ],
    verify: (_) async => verifyNever(
        mockedFirebaseAuthFacade.signUpWithEmailAndPassword(
            email: Email('a@b.com'), password: Password('a'))),
  );
}
