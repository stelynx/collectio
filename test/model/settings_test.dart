import 'package:collectio/model/settings.dart';
import 'package:collectio/util/constant/collectio_theme.dart';
import 'package:collectio/util/constant/language.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Settings settings = Settings(
    theme: CollectioTheme.LIGHT,
    language: Language.en,
  );
  final Map<String, dynamic> settingsJson = <String, dynamic>{
    'theme': 'LIGHT',
    'language': 'en',
  };

  group('fromJson', () {
    test('should get correct Settings object from JSON', () {
      expect(Settings.fromJson(settingsJson), equals(settings));
    });
  });

  group('toJson', () {
    test('should get correct JSON from Settings object', () {
      expect(settings.toJson(), equals(settingsJson));
    });
  });

  group('equality', () {
    test('should two instances with same fields be equal', () {
      final Settings settings2 = Settings(
        theme: CollectioTheme.LIGHT,
        language: Language.en,
      );

      expect(settings2, equals(settings));
    });
  });
}
