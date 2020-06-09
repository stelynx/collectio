import 'failure.dart';

/// Validation failure should be returned in case
/// a validation of user's input fails. The names of failures
/// are completely self-explanatory.
abstract class ValidationFailure extends Failure {}

class EmailEmptyValidationFailure extends ValidationFailure {}

class EmailValidationFailure extends ValidationFailure {}

class PasswordTooShortValidationFailure extends ValidationFailure {}

class PasswordValidationFailure extends ValidationFailure {}

class UsernameTooShortValidationFailure extends ValidationFailure {}

class UsernameValidationFailure extends ValidationFailure {}

class NameEmptyValidationFailure extends ValidationFailure {}

class TitleEmptyValidationFailure extends ValidationFailure {}

class TitleValidationFailure extends ValidationFailure {}

class SubtitleEmptyValidationFailure extends ValidationFailure {}

class DescriptionEmptyValidationFailure extends ValidationFailure {}

class NoPhotoValidationFailure extends ValidationFailure {}
