import 'package:collectio/core/utils/function/validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isValidEmail', () {
    test('should return true on valid email address', () {
      final String email = 'a@b.c';

      final bool result = isValidEmail(email);

      expect(result, isTrue);
    });

    test('should return false on email address without @', () {
      final String email = 'a.b.c';

      final bool result = isValidEmail(email);

      expect(result, isFalse);
    });

    test('should return false on email address without .', () {
      final String email = 'a@b@c';

      final bool result = isValidEmail(email);

      expect(result, isFalse);
    });

    test('should return false on email address with . before @', () {
      final String email = 'a.b@c';

      final bool result = isValidEmail(email);

      expect(result, isFalse);
    });
  });

  group('isValidPassword', () {
    test('should return true on valid password', () {
      final String password =
          'qwertyuiopasdfghjklzxcvbnm[];\\,./\'`~<>?:"|{}!@#\$%^&*()-=_+1234567890';

      final bool result = isValidPassword(password);

      expect(result, isTrue);
    });

    test('should return false on invalid password', () {
      final String password = '';

      final bool result = isValidPassword(password);

      expect(result, isFalse);
    });
  });
}
