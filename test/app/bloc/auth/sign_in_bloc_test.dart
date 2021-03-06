import 'package:bloc_test/bloc_test.dart';
import 'package:collectio/app/bloc/auth/sign_in_bloc.dart';
import 'package:collectio/facade/auth/auth_facade.dart';
import 'package:collectio/facade/auth/firebase/firebase_auth_facade.dart';
import 'package:collectio/facade/profile/firebase/firebase_profile_facade.dart';
import 'package:collectio/facade/profile/profile_facade.dart';
import 'package:collectio/facade/settings/firebase/firebase_settings_facade.dart';
import 'package:collectio/facade/settings/settings_facade.dart';
import 'package:collectio/model/user_profile.dart';
import 'package:collectio/model/value_object/email.dart';
import 'package:collectio/model/value_object/password.dart';
import 'package:collectio/model/value_object/username.dart';
import 'package:collectio/util/constant/translation.dart';
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
  final MockedFirebaseSettingsFacade mockedFirebaseSettingsFacade =
      getIt<SettingsFacade>();

  blocTest(
    'should change state.email on email change',
    build: () async => SignInBloc(
      authFacade: mockedFirebaseAuthFacade,
      profileFacade: mockedFirebaseProfileFacade,
      settingsFacade: mockedFirebaseSettingsFacade,
    ),
    act: (SignInBloc bloc) async =>
        bloc..add(EmailChangedSignInEvent(email: 'a')),
    expect: [
      GeneralSignInState(
        email: Email('a'),
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
      settingsFacade: mockedFirebaseSettingsFacade,
    ),
    act: (SignInBloc bloc) async =>
        bloc..add(PasswordChangedSignInEvent(password: '123456')),
    expect: [
      GeneralSignInState(
        password: Password('123456'),
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
      settingsFacade: mockedFirebaseSettingsFacade,
    ),
    act: (SignInBloc bloc) async =>
        bloc..add(UsernameChangedSignInEvent(username: 'a')),
    expect: [
      GeneralSignInState(
        username: Username('a'),
        authFailure: null,
      ),
    ],
  );

  blocTest(
    'should not change state when signing in with invalid email',
    build: () async => SignInBloc(
      authFacade: mockedFirebaseAuthFacade,
      profileFacade: mockedFirebaseProfileFacade,
      settingsFacade: mockedFirebaseSettingsFacade,
    ),
    act: (SignInBloc bloc) async => bloc
      ..add(PasswordChangedSignInEvent(password: '123456'))
      ..add(SignInWithEmailAndPasswordSignInEvent()),
    expect: [
      GeneralSignInState(
        password: Password('123456'),
      ),
      GeneralSignInState(
        password: Password('123456'),
        showErrorMessages: true,
      ),
    ],
  );

  blocTest(
    'should not change state when signing in with invalid password',
    build: () async => SignInBloc(
      authFacade: mockedFirebaseAuthFacade,
      settingsFacade: mockedFirebaseSettingsFacade,
      profileFacade: mockedFirebaseProfileFacade,
    ),
    act: (SignInBloc bloc) async => bloc
      ..add(EmailChangedSignInEvent(email: 'a@b.c'))
      ..add(SignInWithEmailAndPasswordSignInEvent()),
    expect: [
      GeneralSignInState(email: Email('a@b.c')),
      GeneralSignInState(
        email: Email('a@b.c'),
        showErrorMessages: true,
      ),
    ],
  );

  blocTest(
    'should not change state when registering with invalid email',
    build: () async => SignInBloc(
      authFacade: mockedFirebaseAuthFacade,
      profileFacade: mockedFirebaseProfileFacade,
      settingsFacade: mockedFirebaseSettingsFacade,
    ),
    act: (SignInBloc bloc) async => bloc
      ..add(PasswordChangedSignInEvent(password: '123456'))
      ..add(UsernameChangedSignInEvent(username: 'username'))
      ..add(RegisterWithEmailAndPasswordSignInEvent()),
    expect: [
      GeneralSignInState(
        password: Password('123456'),
      ),
      GeneralSignInState(
        password: Password('123456'),
        username: Username('username'),
      ),
      GeneralSignInState(
        password: Password('123456'),
        username: Username('username'),
        showErrorMessages: true,
      ),
    ],
  );

  blocTest(
    'should not change state when registering with invalid password',
    build: () async => SignInBloc(
      authFacade: mockedFirebaseAuthFacade,
      profileFacade: mockedFirebaseProfileFacade,
      settingsFacade: mockedFirebaseSettingsFacade,
    ),
    act: (SignInBloc bloc) async => bloc
      ..add(EmailChangedSignInEvent(email: 'a@b.c'))
      ..add(UsernameChangedSignInEvent(username: 'aasd'))
      ..add(RegisterWithEmailAndPasswordSignInEvent()),
    expect: [
      GeneralSignInState(email: Email('a@b.c')),
      GeneralSignInState(
        email: Email('a@b.c'),
        username: Username('aasd'),
      ),
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
      settingsFacade: mockedFirebaseSettingsFacade,
    ),
    act: (SignInBloc bloc) async => bloc
      ..add(EmailChangedSignInEvent(email: 'a@b.c'))
      ..add(PasswordChangedSignInEvent(password: '123456'))
      ..add(RegisterWithEmailAndPasswordSignInEvent()),
    expect: [
      GeneralSignInState(email: Email('a@b.c')),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('123456'),
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('123456'),
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
        settingsFacade: mockedFirebaseSettingsFacade,
      );
    },
    act: (SignInBloc bloc) async => bloc
      ..add(EmailChangedSignInEvent(email: 'a@b.c'))
      ..add(PasswordChangedSignInEvent(password: '123456'))
      ..add(SignInWithEmailAndPasswordSignInEvent()),
    expect: [
      GeneralSignInState(
        email: Email('a@b.c'),
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('123456'),
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('123456'),
        showErrorMessages: true,
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('123456'),
        showErrorMessages: true,
        isSubmitting: true,
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('123456'),
        showErrorMessages: true,
        isSubmitting: false,
        authFailure: Left(InvalidCombinationFailure()),
      ),
    ],
    verify: (_) async => verify(
            mockedFirebaseAuthFacade.signInWithEmailAndPassword(
                email: Email('a@b.c'), password: Password('123456')))
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
        settingsFacade: mockedFirebaseSettingsFacade,
      );
    },
    act: (SignInBloc bloc) async => bloc
      ..add(EmailChangedSignInEvent(email: 'a@b.c'))
      ..add(PasswordChangedSignInEvent(password: '123456'))
      ..add(SignInWithEmailAndPasswordSignInEvent()),
    expect: [
      GeneralSignInState(
        email: Email('a@b.c'),
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('123456'),
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('123456'),
        showErrorMessages: true,
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('123456'),
        showErrorMessages: true,
        isSubmitting: true,
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('123456'),
        showErrorMessages: true,
        isSubmitting: false,
        authFailure: Right(null),
      ),
    ],
    verify: (_) async => verify(
            mockedFirebaseAuthFacade.signInWithEmailAndPassword(
                email: Email('a@b.c'), password: Password('123456')))
        .called(1),
  );

  blocTest(
    'should not change state when checking for existing email with invalid email',
    build: () async => SignInBloc(
      authFacade: mockedFirebaseAuthFacade,
      profileFacade: mockedFirebaseProfileFacade,
      settingsFacade: mockedFirebaseSettingsFacade,
    ),
    act: (SignInBloc bloc) async => bloc
      ..add(PasswordChangedSignInEvent(password: '123456'))
      ..add(CheckIfEmailExistsSignInEvent()),
    expect: [
      GeneralSignInState(
        password: Password('123456'),
      ),
      GeneralSignInState(
        password: Password('123456'),
        showErrorMessages: true,
      )
    ],
  );

  blocTest(
    'should not change state when checking for existing email with invalid password',
    build: () async => SignInBloc(
      authFacade: mockedFirebaseAuthFacade,
      profileFacade: mockedFirebaseProfileFacade,
      settingsFacade: mockedFirebaseSettingsFacade,
    ),
    act: (SignInBloc bloc) async => bloc
      ..add(EmailChangedSignInEvent(email: 'a@b.c'))
      ..add(CheckIfEmailExistsSignInEvent()),
    expect: [
      GeneralSignInState(email: Email('a@b.c')),
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
        settingsFacade: mockedFirebaseSettingsFacade,
      );
    },
    act: (SignInBloc bloc) async => bloc
      ..add(EmailChangedSignInEvent(email: 'a@b.c'))
      ..add(PasswordChangedSignInEvent(password: '123456'))
      ..add(CheckIfEmailExistsSignInEvent()),
    expect: [
      GeneralSignInState(
        email: Email('a@b.c'),
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('123456'),
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('123456'),
        showErrorMessages: true,
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('123456'),
        isRegistering: true,
        isSubmitting: true,
        showErrorMessages: true,
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('123456'),
        isSubmitting: false,
        showErrorMessages: true,
        isRegistering: true,
        authFailure: Right(null),
      ),
    ],
  );

  blocTest(
    'should be able to register when username not in use and create user profile',
    build: () async {
      when(mockedFirebaseProfileFacade.getUserProfileByUsername(
              username: 'username'))
          .thenAnswer((_) async =>
              Left(DataFailure(message: Translation.notExactlyOneObjectFound)));
      when(mockedFirebaseAuthFacade.signUpWithEmailAndPassword(
              email: anyNamed('email'), password: anyNamed('password')))
          .thenAnswer((_) async => Right(null));
      when(mockedFirebaseAuthFacade.getCurrentUser())
          .thenAnswer((_) async => 'userUid');
      return SignInBloc(
        authFacade: mockedFirebaseAuthFacade,
        profileFacade: mockedFirebaseProfileFacade,
        settingsFacade: mockedFirebaseSettingsFacade,
      );
    },
    act: (SignInBloc bloc) async => bloc
      ..add(EmailChangedSignInEvent(email: 'a@b.c'))
      ..add(PasswordChangedSignInEvent(password: '123456'))
      ..add(UsernameChangedSignInEvent(username: 'username'))
      ..add(CheckIfEmailExistsSignInEvent())
      ..add(RegisterWithEmailAndPasswordSignInEvent()),
    expect: [
      GeneralSignInState(
        email: Email('a@b.c'),
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('123456'),
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('123456'),
        username: Username('username'),
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('123456'),
        username: Username('username'),
        showErrorMessages: true,
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('123456'),
        username: Username('username'),
        showErrorMessages: true,
        isRegistering: true,
        isSubmitting: true,
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('123456'),
        username: Username('username'),
        showErrorMessages: true,
        isRegistering: true,
        authFailure: Right(null),
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('123456'),
        username: Username('username'),
        showErrorMessages: true,
        isRegistering: true,
        isSubmitting: true,
      ),
      GeneralSignInState(
        email: Email('a@b.c'),
        password: Password('123456'),
        username: Username('username'),
        isSubmitting: false,
        isRegistering: false,
        showErrorMessages: true,
        authFailure: Right(null),
      ),
    ],
    verify: (_) async => verify(
      mockedFirebaseProfileFacade.addUserProfile(
        userProfile: UserProfile(
          email: 'a@b.c',
          userUid: 'userUid',
          username: 'username',
        ),
      ),
    ),
  );

  blocTest(
    'should not be able to register when username is in use',
    build: () async {
      when(mockedFirebaseProfileFacade.getUserProfileByUsername(
              username: 'username'))
          .thenAnswer((_) async => Right(null));
      return SignInBloc(
        authFacade: mockedFirebaseAuthFacade,
        profileFacade: mockedFirebaseProfileFacade,
        settingsFacade: mockedFirebaseSettingsFacade,
      );
    },
    act: (SignInBloc bloc) async => bloc
      ..add(EmailChangedSignInEvent(email: 'a@b.com'))
      ..add(PasswordChangedSignInEvent(password: '123456'))
      ..add(UsernameChangedSignInEvent(username: 'username'))
      ..add(RegisterWithEmailAndPasswordSignInEvent()),
    expect: [
      GeneralSignInState(
        email: Email('a@b.com'),
      ),
      GeneralSignInState(
        email: Email('a@b.com'),
        password: Password('123456'),
      ),
      GeneralSignInState(
        email: Email('a@b.com'),
        password: Password('123456'),
        username: Username('username'),
      ),
      GeneralSignInState(
        email: Email('a@b.com'),
        password: Password('123456'),
        username: Username('username'),
        showErrorMessages: true,
      ),
      GeneralSignInState(
        email: Email('a@b.com'),
        password: Password('123456'),
        username: Username('username'),
        isRegistering: true,
        showErrorMessages: true,
        authFailure: Left(UsernameAlreadyInUseFailure()),
      ),
    ],
    verify: (_) async => verifyNever(
        mockedFirebaseAuthFacade.signUpWithEmailAndPassword(
            email: Email('a@b.com'), password: Password('123456'))),
  );

  blocTest(
    'should not be able to register when failed to check for username',
    build: () async {
      when(mockedFirebaseProfileFacade.getUserProfileByUsername(
              username: 'username'))
          .thenAnswer((_) async => Left(DataFailure()));
      return SignInBloc(
        authFacade: mockedFirebaseAuthFacade,
        profileFacade: mockedFirebaseProfileFacade,
        settingsFacade: mockedFirebaseSettingsFacade,
      );
    },
    act: (SignInBloc bloc) async => bloc
      ..add(EmailChangedSignInEvent(email: 'a@b.comm'))
      ..add(PasswordChangedSignInEvent(password: '123456'))
      ..add(UsernameChangedSignInEvent(username: 'username'))
      ..add(RegisterWithEmailAndPasswordSignInEvent()),
    expect: [
      GeneralSignInState(
        email: Email('a@b.comm'),
      ),
      GeneralSignInState(
        email: Email('a@b.comm'),
        password: Password('123456'),
      ),
      GeneralSignInState(
        email: Email('a@b.comm'),
        password: Password('123456'),
        username: Username('username'),
      ),
      GeneralSignInState(
        email: Email('a@b.comm'),
        password: Password('123456'),
        username: Username('username'),
        showErrorMessages: true,
      ),
      GeneralSignInState(
        email: Email('a@b.comm'),
        password: Password('123456'),
        username: Username('username'),
        isRegistering: true,
        showErrorMessages: true,
        authFailure: Left(ServerFailure()),
      ),
    ],
    verify: (_) async => verifyNever(
        mockedFirebaseAuthFacade.signUpWithEmailAndPassword(
            email: Email('a@b.com'), password: Password('123456'))),
  );

  blocTest(
    'should set isRegistering to false on CancelRegistration',
    build: () async => SignInBloc(
      authFacade: mockedFirebaseAuthFacade,
      profileFacade: mockedFirebaseProfileFacade,
      settingsFacade: mockedFirebaseSettingsFacade,
    ),
    act: (SignInBloc bloc) async => bloc.add(CancelRegistrationSignInEvent()),
    expect: [GeneralSignInState(isRegistering: false)],
  );
}
