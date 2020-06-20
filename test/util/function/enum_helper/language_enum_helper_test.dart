import 'package:collectio/util/constant/language.dart';
import 'package:collectio/util/function/enum_helper/language_enum_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mapEnumToString', () {
    test('should map Language.en to LanguageEnumHelper.english', () {
      final Language language = Language.en;

      final String result = LanguageEnumHelper.mapEnumToString(language);

      expect(result, equals(LanguageEnumHelper.english));
    });

    test('should map Language.de to LanguageEnumHelper.german', () {
      final Language language = Language.de;

      final String result = LanguageEnumHelper.mapEnumToString(language);

      expect(result, equals(LanguageEnumHelper.german));
    });

    test('should map Language.sl to LanguageEnumHelper.slovene', () {
      final Language language = Language.sl;

      final String result = LanguageEnumHelper.mapEnumToString(language);

      expect(result, equals(LanguageEnumHelper.slovene));
    });

    test('should map Language.fr to LanguageEnumHelper.french', () {
      final Language language = Language.fr;

      final String result = LanguageEnumHelper.mapEnumToString(language);

      expect(result, equals(LanguageEnumHelper.french));
    });

    test('should map Language.it to LanguageEnumHelper.italian', () {
      final Language language = Language.it;

      final String result = LanguageEnumHelper.mapEnumToString(language);

      expect(result, equals(LanguageEnumHelper.italian));
    });

    test('should map Language.es to LanguageEnumHelper.spanish', () {
      final Language language = Language.es;

      final String result = LanguageEnumHelper.mapEnumToString(language);

      expect(result, equals(LanguageEnumHelper.spanish));
    });

    test('should map unknown language to empty string', () {
      final Language language = null;

      final String result = LanguageEnumHelper.mapEnumToString(language);

      expect(result, equals(''));
    });
  });

  group('mapStringToEnum', () {
    test('should map LanguageEnumHelper.english to Language.en', () {
      final String language = LanguageEnumHelper.english;

      final Language result = LanguageEnumHelper.mapStringToEnum(language);

      expect(result, equals(Language.en));
    });

    test('should map LanguageEnumHelper.german to Language.de', () {
      final String language = LanguageEnumHelper.german;

      final Language result = LanguageEnumHelper.mapStringToEnum(language);

      expect(result, equals(Language.de));
    });

    test('should map LanguageEnumHelper.slovene to Language.sl', () {
      final String language = LanguageEnumHelper.slovene;

      final Language result = LanguageEnumHelper.mapStringToEnum(language);

      expect(result, equals(Language.sl));
    });

    test('should map LanguageEnumHelper.french to Language.fr', () {
      final String language = LanguageEnumHelper.french;

      final Language result = LanguageEnumHelper.mapStringToEnum(language);

      expect(result, equals(Language.fr));
    });

    test('should map LanguageEnumHelper.italian to Language.it', () {
      final String language = LanguageEnumHelper.italian;

      final Language result = LanguageEnumHelper.mapStringToEnum(language);

      expect(result, equals(Language.it));
    });

    test('should map LanguageEnumHelper.spanish to Language.es', () {
      final String language = LanguageEnumHelper.spanish;

      final Language result = LanguageEnumHelper.mapStringToEnum(language);

      expect(result, equals(Language.es));
    });

    test('should map unknown language to null', () {
      final String language = null;

      final Language result = LanguageEnumHelper.mapStringToEnum(language);

      expect(result, isNull);
    });
  });
}
