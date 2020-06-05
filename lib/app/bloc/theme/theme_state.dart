part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  final ThemeData theme;
  final CollectioTheme themeType;

  ThemeState({@required this.themeType})
      : theme = CollectioThemeManager.getTheme(themeType);

  @override
  List<Object> get props => [theme];
}

class InitialThemeState extends ThemeState {
  InitialThemeState({
    @required CollectioTheme themeType,
  }) : super(themeType: themeType);
}

class GeneralThemeState extends ThemeState {
  GeneralThemeState({@required CollectioTheme themeType})
      : super(themeType: themeType);
}
