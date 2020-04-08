import 'package:collectio/model/password.dart';
import 'package:collectio/util/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should have Left(PasswordValidationFailure) on invalid password', () {
    final Password result = Password('');

    expect(result.value, equals(Left(PasswordValidationFailure())));
  });

  test('should have Right(password) on valid password', () {
    final Password result = Password('a');

    expect(result.value, equals(Right('a')));
  });
}