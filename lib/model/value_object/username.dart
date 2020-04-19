import 'package:dartz/dartz.dart';

import '../../util/error/validation_failure.dart';
import '../../util/function/validator.dart';
import '../interface/validatable.dart';

class Username extends Validatable<String> {
  @override
  final Either<ValidationFailure, String> value;

  factory Username(String input) {
    return Username._(Validator.isValidUsername(input));
  }

  const Username._(this.value);
}
