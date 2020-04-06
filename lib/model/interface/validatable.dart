import 'package:dartz/dartz.dart';

import '../../util/error/validation_failure.dart';

abstract class Validatable<T> {
  const Validatable();

  Either<ValidationFailure, T> get value;

  bool isValid() => value.isRight();

  T get() => value.getOrElse(() => null);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Validatable<T> && value == other.value;
  }

  @override
  int get hashCode => value.hashCode;
}
