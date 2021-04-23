import 'package:collectio/util/constant/constants.dart';
import 'package:flutter/material.dart';

import '../../platform/system_information.dart';
import '../../util/constant/collectio_theme.dart';
import '../../util/injection/injection.dart';
import 'dark.dart' as Dark;
import 'light.dart' as Light;
import 'style.dart';

class CollectioThemeManager {
  static final SystemInformation systemInformation = getIt<SystemInformation>();

  static ThemeData getTheme(CollectioTheme themeType) {
    switch (themeType) {
      case CollectioTheme.LIGHT:
        return _light;
      case CollectioTheme.DARK:
        return _dark;
      case CollectioTheme.SYSTEM:
        final Brightness deviceBrightness = systemInformation.getBrightness();

        if (deviceBrightness == Brightness.light) return _light;
        return _dark;
    }

    throw Exception('Unknown theme');
  }

  static ThemeData get _light => _theme(
        base: ThemeData.light(),
        primaryBrightness: Light.primaryBrightness,
        primaryColor: Light.primaryColor,
        backgroundColor: Light.backgroundColor,
        backgroundDarkerColor: Light.backgroundDarkerColor,
        textColor: Light.textColor,
        errorColor: Light.errorColor,
        addColor: Light.addColor,
      );

  static ThemeData get _dark => _theme(
        base: ThemeData.dark(),
        primaryBrightness: Dark.primaryBrightness,
        primaryColor: Dark.primaryColor,
        backgroundColor: Dark.backgroundColor,
        backgroundDarkerColor: Dark.backgroundDarkerColor,
        textColor: Dark.textColor,
        errorColor: Dark.errorColor,
        addColor: Dark.addColor,
      );

  static ThemeData _theme({
    @required ThemeData base,
    @required Brightness primaryBrightness,
    @required Color primaryColor,
    @required Color backgroundColor,
    @required Color backgroundDarkerColor,
    @required Color textColor,
    @required Color errorColor,
    @required Color addColor,
  }) {
    final TextTheme textTheme = base.textTheme.copyWith(
      headline1: base.textTheme.headline1.copyWith(
        color: textColor,
      ),
      headline2: TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      button: TextStyle(
        fontSize: 15,
      ),
    );

    final IconThemeData iconTheme = IconThemeData(
      color: textColor,
      size: 25,
    );

    final AppBarTheme appBarTheme = AppBarTheme(
      color: backgroundColor,
      brightness: primaryBrightness,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
      iconTheme: iconTheme,
      actionsIconTheme: iconTheme,
      elevation: 0,
    );

    final FloatingActionButtonThemeData floatingActionButtonThemeData =
        base.floatingActionButtonTheme.copyWith(
      elevation: CollectioStyle.elevation,
      foregroundColor: addColor,
      backgroundColor: backgroundDarkerColor,
    );

    final DialogTheme dialogTheme = base.dialogTheme.copyWith(
      backgroundColor: backgroundDarkerColor,
      elevation: CollectioStyle.elevation,
      titleTextStyle: textTheme.headline1.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: textTheme.subtitle2,
      shape: RoundedRectangleBorder(borderRadius: CollectioStyle.borderRadius),
    );

    final DividerThemeData dividerTheme = base.dividerTheme.copyWith(
      color: textColor,
    );

    return base.copyWith(
      primaryColor: primaryColor,
      primaryColorBrightness: primaryBrightness,
      backgroundColor: backgroundColor,
      scaffoldBackgroundColor: backgroundColor,
      errorColor: errorColor,
      buttonColor: backgroundDarkerColor,
      textTheme: textTheme,
      accentTextTheme: textTheme,
      appBarTheme: appBarTheme,
      iconTheme: iconTheme,
      floatingActionButtonTheme: floatingActionButtonThemeData,
      dialogTheme: dialogTheme,
      dividerTheme: dividerTheme,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }

  static Widget poweredByGoogleImage(BuildContext context) {
    return Image.asset(systemInformation.getBrightness() == Brightness.light
        ? Constants.poweredByGoogleLight
        : Constants.poweredByGoogleDark);
  }
}
