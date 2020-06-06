class Constants {
  static const String firebaseStorageBucket =
      'gs://stelynx-collectio.appspot.com';

  // FirebaseAuth errors
  static const String emailAlreadyInUseError = 'ERROR_EMAIL_ALREADY_IN_USE';
  static const String wrongPasswordError = 'ERROR_WRONG_PASSWORD';
  static const String userNotFoundError = 'ERROR_USER_NOT_FOUND';
  static const String emailMalformedError = 'ERROR_INVALID_CREDENTIAL';

  // Messages for ErrorScreen
  static const String unknownRouteMessage = 'Unknown route';
  static const String unknownStateMessage = 'Your app is in unknown state!';

  // Firestore
  static const String userCollection = 'stelynx_user';
  static const String userUidField = 'userUid';
  static const String usernameField = 'username';
  static const String settingsCollection = 'stelynx_settings';

  // AuthFailure messages
  static const String invalidCombination = 'Invalid username and password';
  static const String cannotSignout = 'Cannot sign out right now';
  static const String emailInUse = 'Email already in use';
  static const String usernameInUse = 'Username already in use';
  static const String serverFailure = 'Server error, please try again';

  // DataFailure messages
  static const String notExactlyOneObjectFound =
      'Zero or too many objects found';
  static const String noItems = 'There were no items matching this criteria';
  static const String collectionTitleExists =
      'A title provided maps to the existing collection';

  static const String collectionItemsFailure =
      'An error occured while fetching items, please refresh';
  // ValidationFailure messages
  static const String emptyValidationFailure = 'Cannot be empty';
  static const String titleValidationFailure =
      'Title can contain only alphanumeric values and spaces';
  static const String subtitleValidationFailure = 'Invalid subtitle';
  static const String descriptionValidationFailure = 'Invalid description';

  // Deletion messages
  static const String collectionDeleted = 'Collection successfully deleted!';
  static const String collectionItemDeleted = 'Item successfully deleted!';
  static const String collectionDeletionFailed =
      'Collection could not be deleted!';
  static const String collectionItemDeletionFailed =
      'Item could not be deleted!';
}
