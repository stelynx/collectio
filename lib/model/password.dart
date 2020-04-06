import 'package:dartz/dartz.dart';

import '../util/error/failure.dart';
import '../util/function/validator.dart';
import 'interface/validatable.dart';

class Password extends Validatable {
  @override
  final Either<ValidationFailure, String> value;

  factory Password(String input) {
    assert(input != null);
    return Password._(Validator.isValidPassword(input));
  }

  const Password._(this.value);
}
