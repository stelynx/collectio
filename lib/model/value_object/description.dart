import 'package:dartz/dartz.dart';

import '../../util/error/validation_failure.dart';
import '../../util/function/validator.dart';
import '../interface/validatable.dart';

class Description extends Validatable<String> {
  @override
  final Either<ValidationFailure, String> value;

  factory Description(String input) {
    return Description._(Validator.isValidDescription(input));
  }

  const Description._(this.value);
}
