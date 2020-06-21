part of 'app_configuration_bloc.dart';

class AppConfigurationState extends Equatable {
  final CollectioTheme theme;
  final Language language;

  AppConfigurationState({@required this.theme, @required this.language});

  factory AppConfigurationState.fromSettings(Settings settings) =>
      AppConfigurationState(
        theme: settings.theme,
        language: settings.language,
      );

  @override
  List<Object> get props => [theme, language];
}

class InitialAppConfigurationState extends AppConfigurationState {
  InitialAppConfigurationState()
      : super(
          theme: Settings.defaults().theme,
          language: Settings.defaults().language,
        );
}
