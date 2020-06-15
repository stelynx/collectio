import 'package:bloc_test/bloc_test.dart';
import 'package:collectio/app/bloc/profile/profile_bloc.dart';
import 'package:collectio/app/bloc/settings/settings_bloc.dart';
import 'package:collectio/facade/settings/settings_facade.dart';
import 'package:collectio/model/settings.dart';
import 'package:collectio/model/user_profile.dart';
import 'package:collectio/util/constant/collectio_theme.dart';
import 'package:collectio/util/constant/language.dart';
import 'package:collectio/util/error/data_failure.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;
import 'package:mockito/mockito.dart';

import '../../../mocks.dart';

void main() {
  configureInjection(Environment.test);

  final SettingsFacade settingsFacade = getIt<SettingsFacade>();
  final ProfileBloc profileBloc = getIt<ProfileBloc>();

  final UserProfile profile = UserProfile(
    email: 'a@b.c',
    userUid: 'userUid',
    username: 'username',
  );
  final Settings settings = Settings(
    theme: CollectioTheme.LIGHT,
    language: Language.en,
  );

  tearDownAll(() {
    profileBloc.close();
  });

  blocTest(
    'should yield Empty on Reset',
    build: () async {
      when(profileBloc.listen(any))
          .thenReturn(MockedStreamSubscription<ProfileState>());
      return SettingsBloc(
          settingsFacade: settingsFacade, profileBloc: profileBloc);
    },
    act: (SettingsBloc bloc) async => bloc.add(ResetSettingsEvent()),
    expect: [EmptySettingsState()],
  );

  blocTest(
    'should yield Complete on Get when profile is complete and settings were gotten',
    build: () async {
      when(profileBloc.listen(any))
          .thenReturn(MockedStreamSubscription<ProfileState>());
      when(profileBloc.state).thenReturn(CompleteProfileState(profile));
      when(settingsFacade.getSettings(username: anyNamed('username')))
          .thenAnswer((_) async => Right(settings));
      return SettingsBloc(
          settingsFacade: settingsFacade, profileBloc: profileBloc);
    },
    act: (SettingsBloc bloc) async => bloc.add(GetSettingsEvent()),
    expect: [CompleteSettingsState(settings)],
  );

  blocTest(
    'should yield Error on Get when profile is complete but failed to get settings',
    build: () async {
      when(profileBloc.listen(any))
          .thenReturn(MockedStreamSubscription<ProfileState>());
      when(profileBloc.state).thenReturn(CompleteProfileState(profile));
      when(settingsFacade.getSettings(username: anyNamed('username')))
          .thenAnswer((_) async => Left(DataFailure()));
      return SettingsBloc(
          settingsFacade: settingsFacade, profileBloc: profileBloc);
    },
    act: (SettingsBloc bloc) async => bloc.add(GetSettingsEvent()),
    expect: [ErrorSettingsState()],
  );

  blocTest(
    'should yield nothing on Get when profile is not complete',
    build: () async {
      when(profileBloc.listen(any))
          .thenReturn(MockedStreamSubscription<ProfileState>());
      when(profileBloc.state).thenReturn(EmptyProfileState());
      return SettingsBloc(
          settingsFacade: settingsFacade, profileBloc: profileBloc);
    },
    act: (SettingsBloc bloc) async => bloc.add(GetSettingsEvent()),
    expect: [],
  );
}
