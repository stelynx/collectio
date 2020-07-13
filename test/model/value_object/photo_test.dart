import 'package:collectio/model/value_object/photo.dart';
import 'package:collectio/util/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks.dart';

void main() {
  final MockedFile mockedFile = MockedFile();

  test('should have Right(photo) as value when file supplied', () {
    final Photo photo = Photo(mockedFile);

    expect(photo.value, equals(Right(mockedFile)));
  });

  test(
    'should have Left(NoPhotoValidationFailure) as value when file not supplied',
    () {
      final Photo photo = Photo(null);

      expect(photo.value, equals(Left(NoPhotoValidationFailure())));
    },
  );

  test('should be able to equate two Photo instances with same file', () {
    final Photo photo1 = Photo(mockedFile);
    final Photo photo2 = Photo(mockedFile);

    expect(photo1, equals(photo2));
  });

  test('should two Photo instances with same file have same hashcode', () {
    final Photo photo1 = Photo(mockedFile);
    final Photo photo2 = Photo(mockedFile);

    expect(photo1.hashCode, equals(photo2.hashCode));
  });
}
