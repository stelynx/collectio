import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/utils/error/failure.dart';
import '../../../repository/auth/auth_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepository _authRepository;

  SignInBloc({@required AuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  SignInState get initialState => InitialSignInState();

  @override
  Stream<SignInState> mapEventToState(
    SignInEvent event,
  ) async* {
    if (event is EmailChangedSignInEvent) {
      yield state.copyWith(email: event.email);
    } else if (event is PasswordChangedSignInEvent) {
      yield state.copyWith(password: event.password);
    } else if (event is SignInWithEmailAndPasswordSignInEvent) {
      yield* _callAuthRepositoryWithEmailAndPassword(
          _authRepository.signInWithEmailAndPassword);
    } else if (event is RegisterWithEmailAndPasswordSignInEvent) {
      yield* _callAuthRepositoryWithEmailAndPassword(
          _authRepository.signUpWithEmailAndPassword);
    }
  }

  Stream<SignInState> _callAuthRepositoryWithEmailAndPassword(
    Future<Either<AuthFailure, void>> Function({
      @required String email,
      @required String password,
    })
        authRepositoryMethod,
  ) async* {
    yield state.copyWith(
      isSubmitting: true,
      authFailure: Right(null),
    );

    final Either<AuthFailure, void> result = await authRepositoryMethod(
      email: state.email,
      password: state.password,
    );

    yield state.copyWith(
      isSubmitting: false,
      authFailure: result,
    );
  }
}
