import 'package:collectio/model/value_object/email.dart';
import 'package:collectio/util/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should have Left(EmailEmpty) on empty email', () {
    final Email result = Email('');

    expect(result.value, equals(Left(EmailEmptyValidationFailure())));
  });

  test('should have Left(EmailValidationFailure) on invalid email', () {
    final Email result = Email('a');

    expect(result.value, equals(Left(EmailValidationFailure())));
  });

  test('should have Right(email) on valid email', () {
    final Email result = Email('a@b.c');

    expect(result.value, equals(Right('a@b.c')));
  });

  test('should instances with same email have same hash code', () {
    final Email email1 = Email('a@b.c');
    final Email email2 = Email('a@b.c');

    expect(email1.hashCode, equals(email2.hashCode));
  });
}
