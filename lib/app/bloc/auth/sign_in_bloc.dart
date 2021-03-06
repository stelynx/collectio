import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../facade/auth/auth_facade.dart';
import '../../../facade/profile/profile_facade.dart';
import '../../../facade/settings/settings_facade.dart';
import '../../../model/settings.dart';
import '../../../model/user_profile.dart';
import '../../../model/value_object/email.dart';
import '../../../model/value_object/password.dart';
import '../../../model/value_object/username.dart';
import '../../../util/constant/translation.dart';
import '../../../util/error/auth_failure.dart';
import '../../../util/error/data_failure.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

/// Bloc used for sign in / register form.
@prod
@injectable
class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthFacade _authFacade;
  final ProfileFacade _profileFacade;
  final SettingsFacade _settingsFacade;

  SignInBloc({
    @required AuthFacade authFacade,
    @required ProfileFacade profileFacade,
    @required SettingsFacade settingsFacade,
  })  : _authFacade = authFacade,
        _profileFacade = profileFacade,
        _settingsFacade = settingsFacade;

  @override
  SignInState get initialState => InitialSignInState();

  @override
  Stream<SignInState> mapEventToState(
    SignInEvent event,
  ) async* {
    if (event is EmailChangedSignInEvent) {
      yield state.copyWith(
        email: Email(event.email),
        authFailure: null,
        overrideAuthFailure: true,
      );
    } else if (event is PasswordChangedSignInEvent) {
      yield state.copyWith(
        password: Password(event.password),
        authFailure: null,
        overrideAuthFailure: true,
      );
    } else if (event is UsernameChangedSignInEvent) {
      yield state.copyWith(
        username: Username(event.username),
        authFailure: null,
        overrideAuthFailure: true,
      );
    } else if (event is SignInWithEmailAndPasswordSignInEvent) {
      yield* _callAuthFacadeWithEmailAndPassword(
          _authFacade.signInWithEmailAndPassword);
    } else if (event is RegisterWithEmailAndPasswordSignInEvent) {
      yield state.copyWith(showErrorMessages: true);

      if (state.username.isValid()) {
        final Either<DataFailure, UserProfile> userProfileOrFailure =
            await _profileFacade.getUserProfileByUsername(
                username: state.username.get());

        bool isUsernameInUse = true;
        Either<AuthFailure, void> authFailure;

        userProfileOrFailure.fold(
          (DataFailure failure) {
            if (failure.message == Translation.notExactlyOneObjectFound) {
              isUsernameInUse = false;
            } else {
              authFailure = Left(ServerFailure());
            }
          },
          (_) {
            authFailure = Left(UsernameAlreadyInUseFailure());
          },
        );

        if (!isUsernameInUse) {
          yield* _callAuthFacadeWithEmailAndPassword(
              _authFacade.signUpWithEmailAndPassword);
        } else {
          yield state.copyWith(
            isRegistering: true,
            isSubmitting: false,
            authFailure: authFailure,
          );
        }
      }
    } else if (event is CheckIfEmailExistsSignInEvent) {
      yield* _callAuthFacadeWithEmail(_authFacade.emailNotExists);
    } else if (event is CancelRegistrationSignInEvent) {
      yield state.copyWith(
        isRegistering: false,
        authFailure: null,
        overrideAuthFailure: true,
      );
    }
  }

  Stream<SignInState> _callAuthFacadeWithEmailAndPassword(
    Future<Either<AuthFailure, void>> Function({
      @required Email email,
      @required Password password,
    })
        authFacadeMethod,
  ) async* {
    yield state.copyWith(showErrorMessages: true);

    if (state.email.isValid() &&
        state.password.isValid() &&
        (!state.isRegistering || state.username.isValid())) {
      yield state.copyWith(
        isSubmitting: true,
        showErrorMessages: true,
        authFailure: null,
        overrideAuthFailure: true,
      );

      final Either<AuthFailure, void> result = await authFacadeMethod(
        email: state.email,
        password: state.password,
      );

      // Create user profile and settings upon successful registration.
      if (state.isRegistering && result.isRight()) {
        final String userUid = await _authFacade.getCurrentUser();
        final UserProfile newUserProfile = UserProfile(
            email: state.email.get(),
            userUid: userUid,
            username: state.username.get());
        await _profileFacade.addUserProfile(userProfile: newUserProfile);
        await _settingsFacade.updateSettings(
          username: state.username.get(),
          settings: Settings.defaults(),
        );
      }

      yield state.copyWith(
        isSubmitting: false,
        showErrorMessages: true,
        isRegistering: state.isRegistering && result.isLeft(),
        authFailure: result,
      );
    }
  }

  Stream<SignInState> _callAuthFacadeWithEmail(
    Future<Either<AuthFailure, void>> Function(Email email) authFacadeMethod, {
    bool isRegistering = true,
  }) async* {
    yield state.copyWith(showErrorMessages: true);

    if (state.email.isValid() && state.password.isValid()) {
      yield state.copyWith(
        isSubmitting: true,
        isRegistering: isRegistering,
        showErrorMessages: true,
        authFailure: null,
        overrideAuthFailure: true,
      );

      final Either<AuthFailure, void> result =
          await authFacadeMethod(state.email);

      yield state.copyWith(
        isSubmitting: false,
        authFailure: result,
        showErrorMessages: true,
      );
    }
  }
}

@test
@injectable
@RegisterAs(SignInBloc)
class MockedSignInBloc extends MockBloc<SignInEvent, SignInState>
    implements SignInBloc {}
