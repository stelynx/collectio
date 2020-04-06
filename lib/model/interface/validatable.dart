import 'package:dartz/dartz.dart';

import '../../util/error/validation_failure.dart';

abstract class Validatable<T> {
  const Validatable();

  Either<ValidationFailure, T> get value;

  bool isValid() => value.isRight();

  T get() => value.getOrElse(() => null);
}
