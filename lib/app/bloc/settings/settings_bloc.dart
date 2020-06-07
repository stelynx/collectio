import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../facade/settings/settings_facade.dart';
import '../../../model/settings.dart';
import '../../../util/error/data_failure.dart';
import '../profile/profile_bloc.dart';

part 'settings_event.dart';
part 'settings_state.dart';

@prod
@lazySingleton
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsFacade _settingsFacade;
  final ProfileBloc _profileBloc;
  StreamSubscription _profileBlocStreamSubscription;

  SettingsBloc({
    @required SettingsFacade settingsFacade,
    @required ProfileBloc profileBloc,
  })  : _settingsFacade = settingsFacade,
        _profileBloc = profileBloc {
    _profileBlocStreamSubscription = _profileBloc.listen((ProfileState state) {
      if (state is CompleteProfileState) {
        this.add(GetSettingsEvent());
      } else if (state is EmptyProfileState) {
        this.add(ResetSettingsEvent());
      }
    });
  }

  @override
  Future<void> close() {
    _profileBlocStreamSubscription.cancel();
    return super.close();
  }

  @override
  SettingsState get initialState => InitialSettingsState();

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is GetSettingsEvent) {
      if (_profileBloc.state is CompleteProfileState) {
        final Either<DataFailure, Settings> result =
            await _settingsFacade.getSettings(
                username: (_profileBloc.state as CompleteProfileState)
                    .userProfile
                    .username);
        if (result.isRight()) {
          yield CompleteSettingsState(result.getOrElse(() => null));
        } else {
          yield ErrorSettingsState();
        }
      }
    } else if (event is ResetSettingsEvent) {
      yield EmptySettingsState();
    }
  }
}

@test
@lazySingleton
@RegisterAs(SettingsBloc)
class MockedSettingsBloc extends MockBloc<SettingsEvent, SettingsState>
    implements SettingsBloc {}
