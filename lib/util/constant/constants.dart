/// Defines all constants used throughout the app.
/// Always prefer defining constants to using
/// "magic strings" in the code.
class Constants {
  static const String firebaseStorageBucket =
      'gs://stelynx-collectio.appspot.com';

  // FirebaseAuth errors
  static const String emailAlreadyInUseError = 'ERROR_EMAIL_ALREADY_IN_USE';
  static const String wrongPasswordError = 'ERROR_WRONG_PASSWORD';
  static const String userNotFoundError = 'ERROR_USER_NOT_FOUND';
  static const String emailMalformedError = 'ERROR_INVALID_CREDENTIAL';

  // Firestore
  static const String userCollection = 'stelynx_user';
  static const String userUidField = 'userUid';
  static const String usernameField = 'username';
  static const String settingsCollection = 'stelynx_settings';
}
