part of 'edit_settings_bloc.dart';

abstract class EditSettingsEvent {
  const EditSettingsEvent();
}

class ChangeThemeEditSettingsEvent extends EditSettingsEvent {
  final CollectioTheme newTheme;

  const ChangeThemeEditSettingsEvent(this.newTheme);
}

class ChangeLanguageEditSettingsEvent extends EditSettingsEvent {
  final Language language;

  const ChangeLanguageEditSettingsEvent(this.language);
}
