import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../core/utils/error/auth_failure.dart';
import '../../repository/auth/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({@required AuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  AuthState get initialState => InitialAuthState();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is CheckStatusAuthEvent) {
      final String userUid = await _authRepository.getCurrentUser();
      yield userUid != null
          ? AuthenticatedAuthState(userUid: userUid)
          : UnauthenticatedAuthState();
    } else if (event is SignedOutAuthEvent) {
      Either<AuthFailure, void> result = await _authRepository.signOut();
      if (result.isRight())
        yield UnauthenticatedAuthState();
      else
        yield state;
    }
  }
}
