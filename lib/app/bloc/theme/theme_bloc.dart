import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../util/constant/collectio_theme.dart';
import '../../theme/theme.dart';
import '../settings/settings_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

/// Bloc that holds currently used theme.
@prod
@lazySingleton
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SettingsBloc _settingsBloc;
  StreamSubscription _settingsBlocStreamSubscription;

  ThemeBloc({
    @required SettingsBloc settingsBloc,
  }) : _settingsBloc = settingsBloc {
    _settingsBlocStreamSubscription =
        _settingsBloc.listen((SettingsState state) {
      if (state is CompleteSettingsState) {
        this.add(ChangeThemeEvent(
            (_settingsBloc.state as CompleteSettingsState).settings.theme));
      } else {
        this.add(ChangeThemeEvent(CollectioTheme.SYSTEM));
      }
    });
  }

  @override
  Future<void> close() {
    _settingsBlocStreamSubscription.cancel();
    return super.close();
  }

  @override
  ThemeState get initialState {
    if (_settingsBloc.state is CompleteSettingsState) {
      return InitialThemeState(
          themeType:
              (_settingsBloc.state as CompleteSettingsState).settings.theme);
    }

    return InitialThemeState(themeType: CollectioTheme.SYSTEM);
  }

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is ChangeThemeEvent) {
      yield GeneralThemeState(themeType: event.theme);
    }
  }
}

@test
@lazySingleton
@RegisterAs(ThemeBloc)
class MockedThemeBloc extends MockBloc<ThemeEvent, ThemeState>
    implements ThemeBloc {}
