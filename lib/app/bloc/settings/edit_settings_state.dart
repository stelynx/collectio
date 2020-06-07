part of 'edit_settings_bloc.dart';

abstract class EditSettingsState extends Equatable {
  final CollectioTheme theme;
  final bool updateSuccessful;
  final bool settingsStateNotComplete;

  const EditSettingsState({
    @required this.theme,
    @required this.updateSuccessful,
    this.settingsStateNotComplete = true,
  });

  @override
  List<Object> get props => [theme, updateSuccessful, settingsStateNotComplete];

  EditSettingsState copyWith({
    CollectioTheme theme,
    bool updateSuccessful,
  }) =>
      GeneralEditSettingsState(
        theme: theme ?? this.theme,
        updateSuccessful: updateSuccessful,
      );
}

class InitialEditSettingsState extends EditSettingsState {
  const InitialEditSettingsState({
    CollectioTheme theme,
    @required bool settingsStateNotComplete,
  }) : super(
          theme: theme,
          updateSuccessful: false,
          settingsStateNotComplete: settingsStateNotComplete,
        );
}

class GeneralEditSettingsState extends EditSettingsState {
  const GeneralEditSettingsState({
    CollectioTheme theme,
    bool updateSuccessful,
  }) : super(
          theme: theme ?? CollectioTheme.LIGHT,
          updateSuccessful: updateSuccessful ?? false,
        );
}
