import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../facade/settings/settings_facade.dart';
import '../../../model/settings.dart';
import '../../../util/constant/collectio_theme.dart';
import '../../../util/constant/language.dart';
import '../../../util/error/data_failure.dart';
import '../profile/profile_bloc.dart';
import 'settings_bloc.dart';

part 'edit_settings_event.dart';
part 'edit_settings_state.dart';

/// Bloc used for edit settings form.
@prod
@injectable
class EditSettingsBloc extends Bloc<EditSettingsEvent, EditSettingsState> {
  final SettingsFacade _settingsFacade;
  final SettingsBloc _settingsBloc;
  final ProfileBloc _profileBloc;

  EditSettingsBloc({
    @required SettingsFacade settingsFacade,
    @required SettingsBloc settingsBloc,
    @required ProfileBloc profileBloc,
  })  : _settingsFacade = settingsFacade,
        _settingsBloc = settingsBloc,
        _profileBloc = profileBloc;

  @override
  EditSettingsState get initialState {
    if (_settingsBloc.state is CompleteSettingsState) {
      final Settings settings =
          (_settingsBloc.state as CompleteSettingsState).settings;

      return InitialEditSettingsState(
        theme: settings.theme,
        language: settings.language,
        settingsStateNotComplete: false,
      );
    }

    return InitialEditSettingsState(
      settingsStateNotComplete: true,
    );
  }

  @override
  Stream<EditSettingsState> mapEventToState(
    EditSettingsEvent event,
  ) async* {
    if (_profileBloc.state is CompleteProfileState) {
      if (event is ChangeThemeEditSettingsEvent) {
        final CollectioTheme oldTheme = state.theme;
        final CollectioTheme newTheme = event.newTheme;

        yield state.copyWith(
          theme: newTheme,
          updateSuccessful: null,
        );

        final Either<DataFailure, void> result =
            await _settingsFacade.updateSettings(
          username:
              (_profileBloc.state as CompleteProfileState).userProfile.username,
          settings: Settings(
            theme: newTheme,
            language: state.language,
          ),
        );

        if (result.isRight()) {
          _settingsBloc.add(GetSettingsEvent());
          yield state.copyWith(updateSuccessful: true);
        } else {
          yield state.copyWith(
            theme: oldTheme,
            updateSuccessful: false,
          );
        }
      } else if (event is ChangeLanguageEditSettingsEvent) {
        final Language oldLanguage = state.language;
        final Language newLanguage = event.language;

        yield state.copyWith(
          language: newLanguage,
          updateSuccessful: null,
        );

        final Either<DataFailure, void> result =
            await _settingsFacade.updateSettings(
          username:
              (_profileBloc.state as CompleteProfileState).userProfile.username,
          settings: Settings(
            theme: state.theme,
            language: newLanguage,
          ),
        );

        if (result.isRight()) {
          _settingsBloc.add(GetSettingsEvent());
          yield state.copyWith(updateSuccessful: true);
        } else {
          yield state.copyWith(
            language: oldLanguage,
            updateSuccessful: false,
          );
        }
      }
    }
  }
}

@test
@injectable
@RegisterAs(EditSettingsBloc)
class MockedEditSettingsBloc
    extends MockBloc<EditSettingsEvent, EditSettingsState>
    implements EditSettingsBloc {}
