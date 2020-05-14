import '../constant/constants.dart';
import 'failure.dart';

abstract class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message: message);
}

class InvalidCombinationFailure extends AuthFailure {
  final String email;
  final String password;

  const InvalidCombinationFailure({
    this.email,
    this.password,
    String message = Constants.invalidCombination,
  }) : super(message);

  @override
  List<Object> get props => [email, password, message];
}

class SignOutFailure extends AuthFailure {
  const SignOutFailure({String message = Constants.cannotSignout})
      : super(message);
}

class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure({String message = Constants.emailInUse})
      : super(message);
}

class UsernameAlreadyInUseFailure extends AuthFailure {
  const UsernameAlreadyInUseFailure({String message = Constants.usernameInUse})
      : super(message);
}

class ServerFailure extends AuthFailure {
  const ServerFailure({String message = Constants.serverFailure})
      : super(message);
}
