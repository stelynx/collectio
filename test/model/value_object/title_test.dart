import 'package:collectio/model/value_object/title.dart';
import 'package:collectio/util/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should have Left(TitleEmpty) on empty title', () {
    final Title result = Title('');

    expect(result.value, equals(Left(TitleEmptyValidationFailure())));
  });

  test('should have Left(TitleValidationFailure) on invalid title', () {
    final Title result = Title('aas@');

    expect(result.value, equals(Left(TitleValidationFailure())));
  });

  test('should have Right(title) on valid title', () {
    final Title result = Title('a valid title');

    expect(result.value, equals(Right('a valid title')));
  });

  test('should instances with same title have same hash code', () {
    final Title title1 = Title('title');
    final Title title2 = Title('title');

    expect(title1.hashCode, equals(title2.hashCode));
  });
}
