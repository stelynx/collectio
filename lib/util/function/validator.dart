import 'package:dartz/dartz.dart';

import '../error/validation_failure.dart';

class Validator {
  static Either<ValidationFailure, String> isValidEmail(String email) {
    if (email == '') return Left(EmailEmptyValidationFailure());

    RegExp emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$");
    return emailRegex.hasMatch(email)
        ? Right(email.trim())
        : Left(EmailValidationFailure());
  }

  static Either<ValidationFailure, String> isValidPassword(String password) {
    RegExp passwordRegex = RegExp(r"^.+$");
    return passwordRegex.hasMatch(password)
        ? Right(password.trim())
        : Left(PasswordValidationFailure());
  }

  static Either<ValidationFailure, String> isValidUsername(String username) {
    if (username.length < 4) return Left(UsernameTooShortValidationFailure());

    RegExp usernameRegex = RegExp(r"^[a-zA-Z0-9]+$");
    return usernameRegex.hasMatch(username)
        ? Right(username)
        : Left(UsernameValidationFailure());
  }
}
