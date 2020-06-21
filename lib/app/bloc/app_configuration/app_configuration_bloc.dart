import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../model/settings.dart';
import '../../../util/constant/collectio_theme.dart';
import '../../../util/constant/language.dart';
import '../settings/settings_bloc.dart';

part 'app_configuration_event.dart';
part 'app_configuration_state.dart';

/// Bloc that holds app configuration acquired from user settings.
@prod
@lazySingleton
class AppConfigurationBloc
    extends Bloc<AppConfigurationEvent, AppConfigurationState> {
  final SettingsBloc _settingsBloc;
  StreamSubscription _settingsBlocStreamSubscription;

  AppConfigurationBloc({
    @required SettingsBloc settingsBloc,
  }) : _settingsBloc = settingsBloc {
    _settingsBlocStreamSubscription =
        _settingsBloc.listen((SettingsState state) {
      if (state is CompleteSettingsState) {
        this.add(ChangeAppConfigurationEvent(
            (_settingsBloc.state as CompleteSettingsState).settings));
      } else if (!(state is InitialSettingsState)) {
        this.add(ChangeAppConfigurationEvent(Settings.defaults()));
      }
    });
  }

  @override
  Future<void> close() {
    _settingsBlocStreamSubscription.cancel();
    return super.close();
  }

  @override
  AppConfigurationState get initialState {
    if (_settingsBloc.state is CompleteSettingsState) {
      return AppConfigurationState.fromSettings(
          (_settingsBloc.state as CompleteSettingsState).settings);
    }

    return InitialAppConfigurationState();
  }

  @override
  Stream<AppConfigurationState> mapEventToState(
    AppConfigurationEvent event,
  ) async* {
    if (event is ChangeAppConfigurationEvent) {
      yield AppConfigurationState.fromSettings(event.settings);
    }
  }
}

@test
@lazySingleton
@RegisterAs(AppConfigurationBloc)
class MockedAppConfigurationBloc
    extends MockBloc<AppConfigurationEvent, AppConfigurationState>
    implements AppConfigurationBloc {}
