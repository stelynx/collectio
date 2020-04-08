import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../facade/auth/auth_facade.dart';
import '../../../model/email.dart';
import '../../../model/password.dart';
import '../../../util/error/auth_failure.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

@prod
@lazySingleton
class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthFacade _authFacade;

  SignInBloc({@required AuthFacade authFacade}) : _authFacade = authFacade;

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
      );
    } else if (event is PasswordChangedSignInEvent) {
      yield state.copyWith(
        password: Password(event.password),
        showErrorMessages: true,
        authFailure: null,
      );
    } else if (event is SignInWithEmailAndPasswordSignInEvent) {
      yield* _callAuthFacadeWithEmailAndPassword(
          _authFacade.signInWithEmailAndPassword);
    } else if (event is RegisterWithEmailAndPasswordSignInEvent) {
      yield* _callAuthFacadeWithEmailAndPassword(
          _authFacade.signUpWithEmailAndPassword);
    }
  }

  Stream<SignInState> _callAuthFacadeWithEmailAndPassword(
    Future<Either<AuthFailure, void>> Function({
      @required Email email,
      @required Password password,
    })
        authFacadeMethod,
  ) async* {
    if (state.email.isValid() && state.password.isValid()) {
      yield state.copyWith(
        isSubmitting: true,
        authFailure: null,
      );

      final Either<AuthFailure, void> result = await authFacadeMethod(
        email: state.email,
        password: state.password,
      );

      yield state.copyWith(
        isSubmitting: false,
        authFailure: result,
      );
    }
  }
}
