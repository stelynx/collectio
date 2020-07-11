import 'package:collectio/model/value_object/password.dart';
import 'package:collectio/util/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should have Left(PasswordValidationFailure) on invalid password', () {
    final Password result = Password('');

    expect(result.value, equals(Left(PasswordValidationFailure())));
  });

  test('should have Right(password) on valid password', () {
    final Password result = Password('123456');

    expect(result.value, equals(Right('123456')));
  });

  test('should instances with same password have same hash code', () {
    final Password password1 = Password('123456');
    final Password password2 = Password('123456');

    expect(password1.hashCode, equals(password2.hashCode));
  });
}
