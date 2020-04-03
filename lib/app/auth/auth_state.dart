part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class InitialAuthState extends AuthState {}

class AuthenticatedAuthState extends AuthState {
  final String userUid;

  const AuthenticatedAuthState({@required this.userUid})
      : assert(userUid != null),
        super();

  @override
  List<Object> get props => [userUid];
}

class UnauthenticatedAuthState extends AuthState {}
