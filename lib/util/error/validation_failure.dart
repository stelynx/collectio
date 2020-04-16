import 'failure.dart';

abstract class ValidationFailure extends Failure {}

class EmailEmptyValidationFailure extends ValidationFailure {}

class EmailValidationFailure extends ValidationFailure {}

class PasswordTooShortValidationFailure extends ValidationFailure {}

class PasswordValidationFailure extends ValidationFailure {}

class UsernameTooShortValidationFailure extends ValidationFailure {}

class UsernameValidationFailure extends ValidationFailure {}
