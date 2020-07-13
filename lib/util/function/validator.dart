import 'dart:io';

import 'package:dartz/dartz.dart';

import '../error/validation_failure.dart';

/// Provides methods for validating user input.
class Validator {
  /// Given [email] is valid, if it contains a character,
  /// followed by @, another character, dot and another character.
  static Either<ValidationFailure, String> isValidEmail(String email) {
    if (email == '') return Left(EmailEmptyValidationFailure());

    final String trimmedEmail = email.trim();
    final RegExp emailRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$");
    return emailRegex.hasMatch(trimmedEmail)
        ? Right(trimmedEmail)
        : Left(EmailValidationFailure());
  }

  /// Password is valid if it contains at least six characters.
  static Either<ValidationFailure, String> isValidPassword(String password) {
    final String trimmedPassword = password.trim();
    return trimmedPassword.length >= 6
        ? Right(trimmedPassword)
        : Left(PasswordValidationFailure());
  }

  /// Username is valid if it contains at least 5 characters
  /// and characters must be alphanumeric.
  static Either<ValidationFailure, String> isValidUsername(String username) {
    final String trimmedUsername = username.trim();
    if (trimmedUsername.length < 4)
      return Left(UsernameTooShortValidationFailure());

    final RegExp usernameRegex = RegExp(r"^[a-zA-Z0-9]+$");
    if (!usernameRegex.hasMatch(trimmedUsername))
      return Left(UsernameValidationFailure());

    final RegExp stelynxRegex = RegExp(r".*?stelynx.*?");
    return stelynxRegex.hasMatch(trimmedUsername.toLowerCase())
        ? Left(UsernameContainsStelynxValidationFailure())
        : Right(trimmedUsername);
  }

  /// Name is valid if it is nonempty.
  static Either<ValidationFailure, String> isValidName(String name) {
    final String trimmedName = name.trim();

    return trimmedName != ''
        ? Right(trimmedName)
        : Left(NameEmptyValidationFailure());
  }

  /// Title is valid if it is nonempty.
  static Either<ValidationFailure, String> isValidTitle(String title) {
    final String trimmedTitle = title.trim();
    return trimmedTitle.length == 0
        ? Left(TitleEmptyValidationFailure())
        : Right(trimmedTitle);
  }

  /// Subtitle is valid if it is nonempty.
  static Either<ValidationFailure, String> isValidSubtitle(String subtitle) {
    final String trimmedSubtitle = subtitle.trim();
    return trimmedSubtitle.length == 0
        ? Left(SubtitleEmptyValidationFailure())
        : Right(trimmedSubtitle);
  }

  /// Description is valid if it is nonempty.
  static Either<ValidationFailure, String> isValidDescription(
      String description) {
    final String trimmedDescription = description.trim();
    return trimmedDescription.length == 0
        ? Left(DescriptionEmptyValidationFailure())
        : Right(trimmedDescription);
  }

  /// Photo is valid if it is not null.
  static Either<ValidationFailure, File> isValidPhoto(File photo) =>
      photo == null ? Left(NoPhotoValidationFailure()) : Right(photo);
}
