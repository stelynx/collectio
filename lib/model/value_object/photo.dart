import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../util/error/validation_failure.dart';
import '../../util/function/validator.dart';
import '../interface/validatable.dart';

class Photo extends Validatable {
  @override
  final Either<ValidationFailure, File> value;

  factory Photo(File file) {
    return Photo._(Validator.isValidPhoto(file));
  }

  const Photo._(this.value);
}
