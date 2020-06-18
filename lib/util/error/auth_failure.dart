import '../constant/translation.dart';
import 'failure.dart';

/// AuthFailure is thrown whenever an authentication
/// event fails. Each different failure should extend
/// this class.
abstract class AuthFailure extends Failure {
  const AuthFailure(Translation message) : super(message: message);
}

/// When user provides invalid email and password
/// combination, return this failure.
class InvalidCombinationFailure extends AuthFailure {
  final String email;
  final String password;

  const InvalidCombinationFailure({
    this.email,
    this.password,
    Translation message = Translation.invalidCombination,
  }) : super(message);

  @override
  List<Object> get props => [email, password, message];
}

/// When signing out fails, return this failure.
class SignOutFailure extends AuthFailure {
  const SignOutFailure({Translation message = Translation.cannotSignout})
      : super(message);
}

/// When user tries to register and the email
/// is already in use, return this failure.
class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure({Translation message = Translation.emailInUse})
      : super(message);
}

/// When user tries to register and the username
/// is already in use, return this failure.
class UsernameAlreadyInUseFailure extends AuthFailure {
  const UsernameAlreadyInUseFailure(
      {Translation message = Translation.usernameInUse})
      : super(message);
}

/// Return this failure whenever unrecognized error occurs.
class ServerFailure extends AuthFailure {
  const ServerFailure({Translation message = Translation.serverFailure})
      : super(message);
}
