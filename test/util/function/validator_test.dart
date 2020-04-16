import 'package:collectio/util/error/validation_failure.dart';
import 'package:collectio/util/function/validator.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isValidEmail', () {
    test('should return back email on valid email address', () {
      final String email = 'a@b.c';

      final Either<ValidationFailure, String> result =
          Validator.isValidEmail(email);

      expect(result, equals(Right(email)));
    });

    test('should return EmailEmptyValidationFailure on empty email', () {
      final String email = '';

      final Either<ValidationFailure, String> result =
          Validator.isValidEmail(email);

      expect(result, equals(Left(EmailEmptyValidationFailure())));
    });

    test('should return EmailValidationFailure on email address without @', () {
      final String email = 'a.b.c';

      final Either<ValidationFailure, String> result =
          Validator.isValidEmail(email);

      expect(result, equals(Left(EmailValidationFailure())));
    });

    test('should return EmailValidationFailure on email address without .', () {
      final String email = 'a@b@c';

      final Either<ValidationFailure, String> result =
          Validator.isValidEmail(email);

      expect(result, equals(Left(EmailValidationFailure())));
    });

    test(
        'should return EmailValidationFailure on email address with . before @',
        () {
      final String email = 'a.b@c';

      final Either<ValidationFailure, String> result =
          Validator.isValidEmail(email);

      expect(result, equals(Left(EmailValidationFailure())));
    });
  });

  group('isValidPassword', () {
    test('should return true on valid password', () {
      final String password =
          'qwertyuiopasdfghjklzxcvbnm[];\\,./\'`~<>?:"|{}!@#\$%^&*()-=_+1234567890';

      final Either<ValidationFailure, String> result =
          Validator.isValidPassword(password);

      expect(result, equals(Right(password)));
    });

    test('should return false on invalid password', () {
      final String password = '';

      final Either<ValidationFailure, String> result =
          Validator.isValidPassword(password);

      expect(result, equals(Left(PasswordValidationFailure())));
    });
  });

  group('isValidUsername', () {
    test('should return failure on short username', () {
      final String username = 'asd';

      final Either<ValidationFailure, String> result =
          Validator.isValidUsername(username);

      expect(result, equals(Left(UsernameTooShortValidationFailure())));
    });

    test('should return failure on bad username', () {
      final String username = 'asda@f';

      final Either<ValidationFailure, String> result =
          Validator.isValidUsername(username);

      expect(result, equals(Left(UsernameValidationFailure())));
    });

    test('should return username on valid input', () {
      final String username = 'as3dA4';

      final Either<ValidationFailure, String> result =
          Validator.isValidUsername(username);

      expect(result, equals(Right(username)));
    });
  });
}
