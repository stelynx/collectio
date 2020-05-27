import 'dart:io';

import 'package:collectio/util/error/validation_failure.dart';
import 'package:collectio/util/function/validator.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks.dart';

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

  group('isValidTitle', () {
    test(
      'should return Left(TitleEmptyValidationFailure) when title is empty',
      () {
        final String title = ' ';

        final Either<ValidationFailure, String> result =
            Validator.isValidTitle(title);

        expect(result, equals(Left(TitleEmptyValidationFailure())));
      },
    );

    test(
      'should return Left(TitleValidationFailure) when title contains illegal characters',
      () {
        final String title = 'ckasd@';

        final Either<ValidationFailure, String> result =
            Validator.isValidTitle(title);

        expect(result, equals(Left(TitleValidationFailure())));
      },
    );

    test(
      'should return Right(title) when title is ok',
      () {
        final String title = 'New Collection 3';

        final Either<ValidationFailure, String> result =
            Validator.isValidTitle(title);

        expect(result, equals(Right(title)));
      },
    );
  });

  group('isValidSubtitle', () {
    test(
      'should return Left(SubtitleEmptyValidationFailure) when subtitle is empty',
      () {
        final String subtitle = ' ';

        final Either<ValidationFailure, String> result =
            Validator.isValidSubtitle(subtitle);

        expect(result, equals(Left(SubtitleEmptyValidationFailure())));
      },
    );

    test(
      'should return Left(SubtitleValidationFailure) when subtitle contains illegal characters',
      () {
        final String subtitle = 'ckasd@';

        final Either<ValidationFailure, String> result =
            Validator.isValidSubtitle(subtitle);

        expect(result, equals(Left(SubtitleValidationFailure())));
      },
    );

    test(
      'should return Right(subtitle) when subtitle is ok',
      () {
        final String subtitle = 'New Collection 3 Subtitle';

        final Either<ValidationFailure, String> result =
            Validator.isValidSubtitle(subtitle);

        expect(result, equals(Right(subtitle)));
      },
    );
  });

  group('isValidDescription', () {
    test(
      'should return Left(DescriptionEmptyValidationFailure) when description is empty',
      () {
        final String description = ' ';

        final Either<ValidationFailure, String> result =
            Validator.isValidDescription(description);

        expect(result, equals(Left(DescriptionEmptyValidationFailure())));
      },
    );

    test(
      'should return Right(description) when description is ok',
      () {
        final String description = 'New Collection 3';

        final Either<ValidationFailure, String> result =
            Validator.isValidDescription(description);

        expect(result, equals(Right(description)));
      },
    );
  });

  group('isValidPhoto', () {
    test('should return Right(photo) when photo is ok', () {
      final File file = MockedFile();

      final Either<ValidationFailure, File> result =
          Validator.isValidPhoto(file);

      expect(result, equals(Right(file)));
    });

    test(
        'should return Left(NoPhotoValidationFailure) when photo is not present',
        () {
      final Either<ValidationFailure, File> result =
          Validator.isValidPhoto(null);

      expect(result, equals(Left(NoPhotoValidationFailure())));
    });
  });
}
