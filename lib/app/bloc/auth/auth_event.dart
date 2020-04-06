part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class CheckStatusAuthEvent extends AuthEvent {}

class SignedOutAuthEvent extends AuthEvent {}
