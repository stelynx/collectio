import 'package:dartz/dartz.dart';

import '../util/error/failure.dart';
import '../util/function/validator.dart';
import 'interface/validatable.dart';

class Password extends Validatable<String> {
  @override
  final Either<ValidationFailure, String> value;

  factory Password(String input) {
    return Password._(Validator.isValidPassword(input));
  }

  const Password._(this.value);
}
