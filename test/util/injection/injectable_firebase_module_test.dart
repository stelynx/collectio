import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collectio/util/constant/constants.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;

void main() {
  // This line is necessary in order to obtain Firestore.
  TestWidgetsFlutterBinding.ensureInitialized();

  configureInjection(Environment.prod);

  group('firebaseAuth', () {
    test('should return FirebaseAuth.instance in production', () {
      // Do not type result, otherwise the test has no point!
      final result = getIt<FirebaseAuth>();

      expect(result.runtimeType.toString(), equals('FirebaseAuth'));
    });
  });

  group('firestore', () {
    test('should return Firestore.instance in production', () {
      // Do not type result, otherwise the test has no point!
      final result = getIt<Firestore>();

      expect(result.runtimeType.toString(), equals('Firestore'));
    });
  });

  group('firebaseStorage', () {
    test(
        'should return FirebaseStorage with correct storageBucket in production',
        () {
      // Do not type result, otherwise the test has no point!
      final result = getIt<FirebaseStorage>();

      expect(result.runtimeType.toString(), equals('FirebaseStorage'));

      final FirebaseStorage firebaseStorage = result;
      expect(firebaseStorage.storageBucket,
          equals(Constants.firebaseStorageBucket));
    });
  });
}
