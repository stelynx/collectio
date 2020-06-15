part of 'edit_settings_bloc.dart';

abstract class EditSettingsState extends Equatable {
  final CollectioTheme theme;
  final Language language;
  final bool updateSuccessful;
  final bool settingsStateNotComplete;

  const EditSettingsState({
    @required this.theme,
    @required this.language,
    @required this.updateSuccessful,
    this.settingsStateNotComplete = true,
  });

  @override
  List<Object> get props => [theme, updateSuccessful, settingsStateNotComplete];

  EditSettingsState copyWith({
    CollectioTheme theme,
    Language language,
    bool updateSuccessful,
  }) =>
      GeneralEditSettingsState(
        theme: theme ?? this.theme,
        language: language ?? this.language,
        updateSuccessful: updateSuccessful,
      );
}

class InitialEditSettingsState extends EditSettingsState {
  const InitialEditSettingsState({
    CollectioTheme theme,
    Language language,
    @required bool settingsStateNotComplete,
  }) : super(
          theme: theme,
          language: language,
          updateSuccessful: false,
          settingsStateNotComplete: settingsStateNotComplete,
        );
}

class GeneralEditSettingsState extends EditSettingsState {
  const GeneralEditSettingsState({
    CollectioTheme theme,
    Language language,
    bool updateSuccessful,
  }) : super(
          theme: theme ?? CollectioTheme.LIGHT,
          language: language ?? Language.en,
          updateSuccessful: updateSuccessful ?? false,
        );
}
