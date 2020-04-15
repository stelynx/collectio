class Constants {
  // FirebaseAuth errors
  static String emailAlreadyInUseError = 'ERROR_EMAIL_ALREADY_IN_USE';
  static String wrongPasswordError = 'ERROR_WRONG_PASSWORD';
  static String userNotFoundError = 'ERROR_USER_NOT_FOUND';
  static String emailMalformedError = 'ERROR_INVALID_CREDENTIAL';

  // Messages for ErrorScreen
  static String unknownRouteMessage = 'Unknown route';
  static String unknownStateMessage = 'Your app is in unknown state!';

  // Firestore
  static String userCollection = 'stelynx_user';
  static String userUidField = 'userUid';
  static String usernameField = 'username';

  // DataFailure messages
  static String notExactlyOneObjectFound = 'Zero or too many objects found';
  static String noItems = 'There were no items matching this criteria.';
}
