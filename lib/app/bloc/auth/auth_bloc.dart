import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../facade/auth/auth_facade.dart';
import '../../../util/error/auth_failure.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Bloc that holds userUid of current user if logged in.
@prod
@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthFacade _authFacade;

  AuthBloc({@required AuthFacade authFacade}) : _authFacade = authFacade;

  @override
  AuthState get initialState => InitialAuthState();

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is CheckStatusAuthEvent) {
      final String userUid = await _authFacade.getCurrentUser();
      yield userUid != null
          ? AuthenticatedAuthState(userUid: userUid)
          : UnauthenticatedAuthState();
    } else if (event is SignedOutAuthEvent) {
      Either<AuthFailure, void> result = await _authFacade.signOut();
      if (result.isRight())
        yield UnauthenticatedAuthState();
      else
        yield state;
    }
  }
}

@test
@lazySingleton
@RegisterAs(AuthBloc)
class MockedAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}
