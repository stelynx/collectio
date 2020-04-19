import 'package:dartz/dartz.dart';

import '../../util/error/validation_failure.dart';
import '../../util/function/validator.dart';
import '../interface/validatable.dart';

class Subtitle extends Validatable<String> {
  @override
  final Either<ValidationFailure, String> value;

  factory Subtitle(String input) {
    return Subtitle._(Validator.isValidSubtitle(input));
  }

  const Subtitle._(this.value);
}
