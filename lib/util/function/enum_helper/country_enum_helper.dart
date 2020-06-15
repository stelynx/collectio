import '../../constant/country.dart';

abstract class CountryEnumHelper {
  static const germany = 'Germany';
  static const uk = 'United Kingdom';
  static const us = 'United States';
  static const slovenia = 'Slovenia';

  static String mapEnumToString(Country enumValue) {
    switch (enumValue) {
      case Country.DE:
        return germany;
      case Country.UK:
        return uk;
      case Country.US:
        return us;
      case Country.SI:
        return slovenia;
      default:
        return '';
    }
  }

  static Country mapStringToEnum(String string) {
    switch (string) {
      case germany:
        return Country.DE;
      case uk:
        return Country.UK;
      case us:
        return Country.US;
      case slovenia:
        return Country.SI;
      default:
        return null;
    }
  }
}
