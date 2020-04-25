import 'package:collectio/model/value_object/subtitle.dart';
import 'package:collectio/util/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should have Left(SubtitleEmpty) on empty subtitle', () {
    final Subtitle result = Subtitle('');

    expect(result.value, equals(Left(SubtitleEmptyValidationFailure())));
  });

  test('should have Left(SubtitleValidationFailure) on invalid subtitle', () {
    final Subtitle result = Subtitle('aas@');

    expect(result.value, equals(Left(SubtitleValidationFailure())));
  });

  test('should have Right(subtitle) on valid subtitle', () {
    final Subtitle result = Subtitle('a valid subtitle');

    expect(result.value, equals(Right('a valid subtitle')));
  });

  test('should instances with same subtitle have same hash code', () {
    final Subtitle subtitle1 = Subtitle('subtitle');
    final Subtitle subtitle2 = Subtitle('subtitle');

    expect(subtitle1.hashCode, equals(subtitle2.hashCode));
  });
}
