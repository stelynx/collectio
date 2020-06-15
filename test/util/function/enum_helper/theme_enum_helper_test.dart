import 'package:collectio/util/constant/collectio_theme.dart';
import 'package:collectio/util/function/enum_helper/theme_enum_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mapEnumToString', () {
    test('should map CollectioTheme.LIGHT to ThemeEnumHelper.light', () {
      final CollectioTheme theme = CollectioTheme.LIGHT;

      final String result = ThemeEnumHelper.mapEnumToString(theme);

      expect(result, equals(ThemeEnumHelper.light));
    });

    test('should map CollectioTheme.DARK to ThemeEnumHelper.dark', () {
      final CollectioTheme theme = CollectioTheme.DARK;

      final String result = ThemeEnumHelper.mapEnumToString(theme);

      expect(result, equals(ThemeEnumHelper.dark));
    });

    test('should map CollectioTheme.SYSTEM to ThemeEnumHelper.system', () {
      final CollectioTheme theme = CollectioTheme.SYSTEM;

      final String result = ThemeEnumHelper.mapEnumToString(theme);

      expect(result, equals(ThemeEnumHelper.system));
    });

    test('should map unknown theme to empty string', () {
      final CollectioTheme theme = null;

      final String result = ThemeEnumHelper.mapEnumToString(theme);

      expect(result, equals(''));
    });
  });

  group('mapStringToEnum', () {
    test('should map ThemeEnumHelper.light to CollectioTheme.LIGHT', () {
      final String theme = ThemeEnumHelper.light;

      final CollectioTheme result = ThemeEnumHelper.mapStringToEnum(theme);

      expect(result, equals(CollectioTheme.LIGHT));
    });

    test('should map ThemeEnumHelper.dark to CollectioTheme.DARK', () {
      final String theme = ThemeEnumHelper.dark;

      final CollectioTheme result = ThemeEnumHelper.mapStringToEnum(theme);

      expect(result, equals(CollectioTheme.DARK));
    });

    test('should map ThemeEnumHelper.system to CollectioTheme.SYSTEM', () {
      final String theme = ThemeEnumHelper.system;

      final CollectioTheme result = ThemeEnumHelper.mapStringToEnum(theme);

      expect(result, equals(CollectioTheme.SYSTEM));
    });

    test('should map unknown theme to null', () {
      final String theme = null;

      final CollectioTheme result = ThemeEnumHelper.mapStringToEnum(theme);

      expect(result, isNull);
    });
  });
}
