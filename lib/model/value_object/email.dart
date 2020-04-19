import 'package:dartz/dartz.dart';

import '../../util/error/validation_failure.dart';
import '../../util/function/validator.dart';
import '../interface/validatable.dart';

class Email extends Validatable<String> {
  @override
  final Either<ValidationFailure, String> value;

  factory Email(String input) {
    return Email._(Validator.isValidEmail(input));
  }

  const Email._(this.value);
}
