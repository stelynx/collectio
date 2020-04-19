import 'package:dartz/dartz.dart';

import '../../util/error/validation_failure.dart';
import '../../util/function/validator.dart';
import '../interface/validatable.dart';

class Title extends Validatable<String> {
  @override
  final Either<ValidationFailure, String> value;

  factory Title(String input) {
    return Title._(Validator.isValidTitle(input));
  }

  const Title._(this.value);
}
