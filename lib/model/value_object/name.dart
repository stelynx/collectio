import 'package:dartz/dartz.dart';

import '../../util/error/validation_failure.dart';
import '../../util/function/validator.dart';
import '../interface/validatable.dart';

class Name extends Validatable<String> {
  @override
  final Either<ValidationFailure, String> value;

  factory Name(String input) {
    return Name._(Validator.isValidName(input));
  }

  const Name._(this.value);
}
