import 'package:collectio/util/constant/country.dart';
import 'package:collectio/util/function/enum_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('enumToString', () {
    test('should return correct string representation', () {
      final Country country = Country.SI;

      final String result = enumToString(country);

      expect(result, equals('SI'));
    });
  });

  group('enumFromString', () {
    test('should return correct Enum representation', () {
      final String country = 'SI';

      final Country result = enumFromString<Country>(country, Country.values);

      expect(result, equals(Country.SI));
    });
  });
}
