import 'package:collectio/model/value_object/description.dart' as model;
import 'package:collectio/util/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
      'should have Left(DescriptionEmptyValidationFailure) on empty description',
      () {
    final model.Description result = model.Description('');

    expect(result.value, equals(Left(DescriptionEmptyValidationFailure())));
  });

  test('should have Right(description) on valid description', () {
    final model.Description result = model.Description('description');

    expect(result.value, equals(Right('description')));
  });

  test('should instances with same description have same hash code', () {
    final model.Description description1 = model.Description('description1');
    final model.Description description2 = model.Description('description1');

    expect(description1.hashCode, equals(description2.hashCode));
  });
}
