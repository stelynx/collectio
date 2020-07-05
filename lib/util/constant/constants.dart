/// Defines all constants used throughout the app.
/// Always prefer defining constants to using
/// "magic strings" in the code.
class Constants {
  static const String firebaseStorageBucket =
      'gs://stelynx-collectio.appspot.com';
  static const String googleApiKey = 'GOOGLE_API_KEY';
  static const String googleMapsPlaceApiUrl =
      'https://maps.googleapis.com/maps/api/place';
  static const String googleMapsGeocodingApiUrl =
      'https://maps.googleapis.com/maps/api/geocode';

  static const String pathCollectioIcon = 'assets/images/collectio_icon.png';

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

  // This constant is not translated because it is shown until
  // the app knows what language to use. It could be translated
  // and app locale picked up, but it is completely useless.
  static const String loadingConfiguration = 'One app to rule them all ...';

  static const int minCharsForAutocomplete = 2;
}
