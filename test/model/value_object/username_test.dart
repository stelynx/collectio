import 'package:collectio/model/value_object/username.dart';
import 'package:collectio/util/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should have Left(UsernameTooShortValidationFailure) on too short email',
      () {
    final Username result = Username('abc');

    expect(result.value, equals(Left(UsernameTooShortValidationFailure())));
  });

  test('should have Left(UsernameValidationFailure) on invalid username', () {
    final Username result = Username('dfasa@');

    expect(result.value, equals(Left(UsernameValidationFailure())));
  });

  test('should have Right(username) on valid username', () {
    final Username result = Username('username');

    expect(result.value, equals(Right('username')));
  });

  test('should instances with same username have same hash code', () {
    final Username username1 = Username('username1');
    final Username username2 = Username('username1');

    expect(username1.hashCode, equals(username2.hashCode));
  });
}
