import 'failure.dart';

abstract class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message: message);
}

class InvalidEmailFailure extends AuthFailure {
  final String email;

  const InvalidEmailFailure({this.email, String message}) : super(message);

  @override
  List<Object> get props => [email, message];
}

class InvalidPasswordFailure extends AuthFailure {
  final String password;

  const InvalidPasswordFailure({this.password, String message})
      : super(message);

  @override
  List<Object> get props => [password, message];
}

class InvalidCombinationFailure extends AuthFailure {
  final String email;
  final String password;

  const InvalidCombinationFailure({this.email, this.password, String message})
      : super(message);

  @override
  List<Object> get props => [email, password, message];
}

class SignOutFailure extends AuthFailure {
  const SignOutFailure({String message}) : super(message);
}

class SignUpFailure extends AuthFailure {
  const SignUpFailure({String message}) : super(message);
}
