import '../../constant/collectio_theme.dart';

abstract class ThemeEnumHelper {
  static const light = 'Light';
  static const dark = 'Dark';
  static const system = 'System';

  static String mapEnumToString(CollectioTheme enumValue) {
    switch (enumValue) {
      case CollectioTheme.LIGHT:
        return light;
      case CollectioTheme.DARK:
        return dark;
      case CollectioTheme.SYSTEM:
        return system;
      default:
        return '';
    }
  }

  static CollectioTheme mapStringToEnum(String string) {
    switch (string) {
      case light:
        return CollectioTheme.LIGHT;
      case dark:
        return CollectioTheme.DARK;
      case system:
        return CollectioTheme.SYSTEM;
      default:
        return null;
    }
  }
}
