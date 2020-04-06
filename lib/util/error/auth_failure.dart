import 'failure.dart';

abstract class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message: message);
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

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure({String message}) : super(message);
}

class ServerFailure extends AuthFailure {
  const ServerFailure({String message}) : super(message);
}
