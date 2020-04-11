import 'package:collectio/util/injection/injection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;

void main() {
  group('firebaseAuth', () {
    test('should return FirebaseAuth.instance in production', () {
      configureInjection(Environment.prod);

      // Do not type result, otherwise the test has no point!
      final result = getIt<FirebaseAuth>();

      expect(result.runtimeType.toString(), equals('FirebaseAuth'));
    });
  });
}
