part of 'sign_in_bloc.dart';

abstract class SignInEvent {
  const SignInEvent();
}

class EmailChangedSignInEvent extends SignInEvent {
  final String email;

  const EmailChangedSignInEvent({@required this.email});
}

class PasswordChangedSignInEvent extends SignInEvent {
  final String password;

  const PasswordChangedSignInEvent({@required this.password});
}

class UsernameChangedSignInEvent extends SignInEvent {
  final String username;

  const UsernameChangedSignInEvent({@required this.username});
}

class SignInWithEmailAndPasswordSignInEvent extends SignInEvent {}

class RegisterWithEmailAndPasswordSignInEvent extends SignInEvent {}

class CheckIfEmailExistsSignInEvent extends SignInEvent {}

class CancelRegistrationSignInEvent extends SignInEvent {}
