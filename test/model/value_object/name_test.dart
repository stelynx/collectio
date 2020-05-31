import 'package:collectio/model/value_object/name.dart';
import 'package:collectio/util/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should have Left(NameEmpty) on empty name', () {
    final Name result = Name('');

    expect(result.value, equals(Left(NameEmptyValidationFailure())));
  });

  test('should have Right(name) on valid name', () {
    final Name result = Name('a valid name');

    expect(result.value, equals(Right('a valid name')));
  });

  test('should instances with same title have same hash code', () {
    final Name name1 = Name('name');
    final Name name2 = Name('name');

    expect(name1.hashCode, equals(name2.hashCode));
  });
}
