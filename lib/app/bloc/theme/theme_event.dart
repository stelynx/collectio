part of 'theme_bloc.dart';

abstract class ThemeEvent {
  const ThemeEvent();
}

class ChangeThemeEvent extends ThemeEvent {
  final CollectioTheme theme;

  const ChangeThemeEvent(this.theme);
}
