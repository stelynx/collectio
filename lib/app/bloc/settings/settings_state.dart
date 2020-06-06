part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class InitialSettingsState extends SettingsState {}

class CompleteSettingsState extends SettingsState {
  final Settings settings;

  const CompleteSettingsState(this.settings);

  @override
  List<Object> get props => [settings];
}

class EmptySettingsState extends SettingsState {}

class ErrorSettingsState extends SettingsState {}
