import '../constant/constants.dart';
import 'failure.dart';

/// AuthFailure is thrown whenever an authentication
/// event fails. Each different failure should extend
/// this class.
abstract class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message: message);
}

/// When user provides invalid email and password
/// combination, return this failure.
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

/// When signing out fails, return this failure.
class SignOutFailure extends AuthFailure {
  const SignOutFailure({String message = Constants.cannotSignout})
      : super(message);
}

/// When user tries to register and the email
/// is already in use, return this failure.
class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure({String message = Constants.emailInUse})
      : super(message);
}

/// When user tries to register and the username
/// is already in use, return this failure.
class UsernameAlreadyInUseFailure extends AuthFailure {
  const UsernameAlreadyInUseFailure({String message = Constants.usernameInUse})
      : super(message);
}

/// Return this failure whenever unrecognized error occurs.
class ServerFailure extends AuthFailure {
  const ServerFailure({String message = Constants.serverFailure})
      : super(message);
}
