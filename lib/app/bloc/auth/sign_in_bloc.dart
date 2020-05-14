import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../facade/auth/auth_facade.dart';
import '../../../facade/profile/profile_facade.dart';
import '../../../model/user_profile.dart';
import '../../../model/value_object/email.dart';
import '../../../model/value_object/password.dart';
import '../../../model/value_object/username.dart';
import '../../../util/constant/constants.dart';
import '../../../util/error/auth_failure.dart';
import '../../../util/error/data_failure.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

@prod
@lazySingleton
class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthFacade _authFacade;
  final ProfileFacade _profileFacade;

  SignInBloc({
    @required AuthFacade authFacade,
    @required ProfileFacade profileFacade,
  })  : _authFacade = authFacade,
        _profileFacade = profileFacade;

  @override
  SignInState get initialState => InitialSignInState();

  @override
  Stream<SignInState> mapEventToState(
    SignInEvent event,
  ) async* {
    if (event is EmailChangedSignInEvent) {
      yield state.copyWith(
        email: Email(event.email),
        showErrorMessages: true,
        authFailure: null,
        overrideAuthFailure: true,
      );
    } else if (event is PasswordChangedSignInEvent) {
      yield state.copyWith(
        password: Password(event.password),
        showErrorMessages: true,
        authFailure: null,
        overrideAuthFailure: true,
      );
    } else if (event is UsernameChangedSignInEvent) {
      yield state.copyWith(
        username: Username(event.username),
        showErrorMessages: true,
        authFailure: null,
        overrideAuthFailure: true,
      );
    } else if (event is SignInWithEmailAndPasswordSignInEvent) {
      yield* _callAuthFacadeWithEmailAndPassword(
          _authFacade.signInWithEmailAndPassword);
    } else if (event is RegisterWithEmailAndPasswordSignInEvent) {
      if (state.username.isValid()) {
        final Either<DataFailure, UserProfile> userProfileOrFailure =
            await _profileFacade.getUserProfileByUsername(
                username: state.username.get());

        bool isUsernameInUse = true;
        Either<AuthFailure, void> authFailure;

        userProfileOrFailure.fold(
          (DataFailure failure) {
            if (failure.message == Constants.notExactlyOneObjectFound) {
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
    }
  }

  Stream<SignInState> _callAuthFacadeWithEmailAndPassword(
    Future<Either<AuthFailure, void>> Function({
      @required Email email,
      @required Password password,
    })
        authFacadeMethod,
  ) async* {
    if (state.email.isValid() &&
        state.password.isValid() &&
        (!state.isRegistering || state.username.isValid())) {
      yield state.copyWith(
        isSubmitting: true,
        authFailure: null,
        overrideAuthFailure: true,
      );

      final Either<AuthFailure, void> result = await authFacadeMethod(
        email: state.email,
        password: state.password,
      );

      // Create user profile upon successful registration.
      if (state.isRegistering && result.isRight()) {
        final String userUid = await _authFacade.getCurrentUser();
        final UserProfile newUserProfile = UserProfile(
            email: state.email.get(),
            userUid: userUid,
            username: state.username.get());
        await _profileFacade.addUserProfile(userProfile: newUserProfile);
      }

      yield state.copyWith(
        isSubmitting: false,
        isRegistering: state.isRegistering && result.isLeft(),
        authFailure: result,
      );
    }
  }

  Stream<SignInState> _callAuthFacadeWithEmail(
    Future<Either<AuthFailure, void>> Function(Email email) authFacadeMethod, {
    bool isRegistering = true,
  }) async* {
    if (state.email.isValid() && state.password.isValid()) {
      yield state.copyWith(
        isSubmitting: true,
        isRegistering: isRegistering,
        authFailure: null,
        overrideAuthFailure: true,
      );

      final Either<AuthFailure, void> result =
          await authFacadeMethod(state.email);

      yield state.copyWith(
        isSubmitting: false,
        authFailure: result,
      );
    }
  }
}

@test
@lazySingleton
@RegisterAs(SignInBloc)
class MockedSignInBloc extends MockBloc<SignInEvent, SignInState>
    implements SignInBloc {}
