part of 'settings_bloc.dart';

abstract class SettingsEvent {
  const SettingsEvent();
}

class GetSettingsEvent extends SettingsEvent {}

class ResetSettingsEvent extends SettingsEvent {}
