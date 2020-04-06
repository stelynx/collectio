part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class EmailChangedSignInEvent extends SignInEvent {
  final String email;

  const EmailChangedSignInEvent({@required this.email});

  @override
  List<Object> get props => [email];
}

class PasswordChangedSignInEvent extends SignInEvent {
  final String password;

  const PasswordChangedSignInEvent({@required this.password});

  @override
  List<Object> get props => [password];
}

class SignInWithEmailAndPasswordSignInEvent extends SignInEvent {}

class RegisterWithEmailAndPasswordSignInEvent extends SignInEvent {}
