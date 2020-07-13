import 'package:collectio/app/theme/dark.dart' as Dark;
import 'package:collectio/app/theme/light.dart' as Light;
import 'package:collectio/app/theme/theme.dart';
import 'package:collectio/util/constant/collectio_theme.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;
import 'package:mockito/mockito.dart';

void main() {
  configureInjection(Environment.test);

  test('should be able to get light theme', () {
    final ThemeData result =
        CollectioThemeManager.getTheme(CollectioTheme.LIGHT);

    expect(result.backgroundColor, equals(Light.backgroundColor));
  });

  test('should be able to get dark theme', () {
    final ThemeData result =
        CollectioThemeManager.getTheme(CollectioTheme.DARK);

    expect(result.backgroundColor, equals(Dark.backgroundColor));
  });

  test('should be able to get light theme based on system', () {
    when(CollectioThemeManager.systemInformation.getBrightness())
        .thenReturn(Brightness.light);

    final ThemeData result =
        CollectioThemeManager.getTheme(CollectioTheme.SYSTEM);

    expect(result.backgroundColor, equals(Light.backgroundColor));
  });

  test('should be able to get dark theme based on system', () {
    when(CollectioThemeManager.systemInformation.getBrightness())
        .thenReturn(Brightness.dark);

    final ThemeData result =
        CollectioThemeManager.getTheme(CollectioTheme.SYSTEM);

    expect(result.backgroundColor, equals(Dark.backgroundColor));
  });

  test('should throw exception on unknown theme', () {
    expect(
      () => CollectioThemeManager.getTheme(null),
      throwsA(isInstanceOf<Exception>()),
    );
  });
}
