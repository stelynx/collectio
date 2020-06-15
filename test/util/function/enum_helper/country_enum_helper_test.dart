import 'package:collectio/util/constant/country.dart';
import 'package:collectio/util/function/enum_helper/country_enum_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mapEnumToString', () {
    test('should map Country.SI to CountryEnumHelper.slovenia', () {
      final Country country = Country.SI;

      final String result = CountryEnumHelper.mapEnumToString(country);

      expect(result, equals(CountryEnumHelper.slovenia));
    });

    test('should map Country.UK to CountryEnumHelper.uk', () {
      final Country country = Country.UK;

      final String result = CountryEnumHelper.mapEnumToString(country);

      expect(result, equals(CountryEnumHelper.uk));
    });

    test('should map Country.US to CountryEnumHelper.us', () {
      final Country country = Country.US;

      final String result = CountryEnumHelper.mapEnumToString(country);

      expect(result, equals(CountryEnumHelper.us));
    });

    test('should map Country.DE to CountryEnumHelper.germany', () {
      final Country country = Country.DE;

      final String result = CountryEnumHelper.mapEnumToString(country);

      expect(result, equals(CountryEnumHelper.germany));
    });

    test('should map unknown country to empty string', () {
      final Country country = null;

      final String result = CountryEnumHelper.mapEnumToString(country);

      expect(result, equals(''));
    });
  });

  group('mapStringToEnum', () {
    test('should map CountryEnumHelper.slovenia to Country.SI', () {
      final String country = CountryEnumHelper.slovenia;

      final Country result = CountryEnumHelper.mapStringToEnum(country);

      expect(result, equals(Country.SI));
    });

    test('should map CountryEnumHelper.uk to Country.UK', () {
      final String country = CountryEnumHelper.uk;

      final Country result = CountryEnumHelper.mapStringToEnum(country);

      expect(result, equals(Country.UK));
    });

    test('should map CountryEnumHelper.us to Country.US', () {
      final String country = CountryEnumHelper.us;

      final Country result = CountryEnumHelper.mapStringToEnum(country);

      expect(result, equals(Country.US));
    });

    test('should map CountryEnumHelper.germany to Country.DE', () {
      final String country = CountryEnumHelper.germany;

      final Country result = CountryEnumHelper.mapStringToEnum(country);

      expect(result, equals(Country.DE));
    });

    test('should map unknown country to null', () {
      final String country = null;

      final Country result = CountryEnumHelper.mapStringToEnum(country);

      expect(result, isNull);
    });
  });
}
