import 'package:dartz/dartz.dart';

import '../error/validation_failure.dart';

class Validator {
  static Either<ValidationFailure, String> isValidEmail(String email) {
    if (email == '') return Left(EmailEmptyValidationFailure());

    final String trimmedEmail = email.trim();
    final RegExp emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$");
    return emailRegex.hasMatch(trimmedEmail)
        ? Right(trimmedEmail)
        : Left(EmailValidationFailure());
  }

  static Either<ValidationFailure, String> isValidPassword(String password) {
    final String trimmedPassword = password.trim();
    final RegExp passwordRegex = RegExp(r"^.+$");
    return passwordRegex.hasMatch(trimmedPassword)
        ? Right(trimmedPassword)
        : Left(PasswordValidationFailure());
  }

  static Either<ValidationFailure, String> isValidUsername(String username) {
    final String trimmedUsername = username.trim();
    if (trimmedUsername.length < 4)
      return Left(UsernameTooShortValidationFailure());

    final RegExp usernameRegex = RegExp(r"^[a-zA-Z0-9]+$");
    return usernameRegex.hasMatch(trimmedUsername)
        ? Right(trimmedUsername)
        : Left(UsernameValidationFailure());
  }
}
