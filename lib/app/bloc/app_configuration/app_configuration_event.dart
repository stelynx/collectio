part of 'app_configuration_bloc.dart';

abstract class AppConfigurationEvent {
  const AppConfigurationEvent();
}

class ChangeAppConfigurationEvent extends AppConfigurationEvent {
  final Settings settings;

  const ChangeAppConfigurationEvent(this.settings);
}

class ResetAppConfigurationEvent extends AppConfigurationEvent {}
