import '../../constant/language.dart';

abstract class LanguageEnumHelper {
  static const german = 'Deutsch';
  static const english = 'English';
  static const spanish = 'Español';
  static const french = 'Français';
  static const italian = 'Italiano';
  static const slovene = 'Slovenščina';

  static String mapEnumToString(Language enumValue) {
    switch (enumValue) {
      case Language.de:
        return german;
      case Language.en:
        return english;
      case Language.es:
        return spanish;
      case Language.fr:
        return french;
      case Language.it:
        return italian;
      case Language.si:
        return slovene;
      default:
        return '';
    }
  }

  static Language mapStringToEnum(String string) {
    switch (string) {
      case german:
        return Language.de;
      case english:
        return Language.en;
      case spanish:
        return Language.es;
      case french:
        return Language.fr;
      case italian:
        return Language.it;
      case slovene:
        return Language.si;
      default:
        return null;
    }
  }
}
