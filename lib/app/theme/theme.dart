import 'package:flutter/material.dart';

import 'dark.dart' as Dark;
import 'light.dart' as Light;
import 'style.dart';

class CollectioTheme {
  static ThemeData get light => _theme(
        base: ThemeData.light(),
        primaryBrightness: Light.primaryBrightness,
        primaryColor: Light.primaryColor,
        backgroundColor: Light.backgroundColor,
        backgroundDarkerColor: Light.backgroundDarkerColor,
        textColor: Light.textColor,
        errorColor: Light.errorColor,
        addColor: Light.addColor,
      );

  static ThemeData get dark => _theme(
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

    return base.copyWith(
      primaryColor: primaryColor,
      primaryColorBrightness: primaryBrightness,
      backgroundColor: backgroundColor,
      scaffoldBackgroundColor: backgroundColor,
      errorColor: errorColor,
      textTheme: textTheme,
      accentTextTheme: textTheme,
      appBarTheme: appBarTheme,
      iconTheme: iconTheme,
      floatingActionButtonTheme: floatingActionButtonThemeData,
    );
  }
}