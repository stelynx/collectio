import 'package:bloc_test/bloc_test.dart';
import 'package:collectio/app/bloc/profile/profile_bloc.dart';
import 'package:collectio/app/bloc/settings/edit_settings_bloc.dart';
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

void main() {
  configureInjection(Environment.test);

  final SettingsFacade settingsFacade = getIt<SettingsFacade>();
  final SettingsBloc settingsBloc = getIt<SettingsBloc>();
  final ProfileBloc profileBloc = getIt<ProfileBloc>();

  final Settings settings = Settings(
    theme: CollectioTheme.LIGHT,
    language: Language.en,
  );
  final UserProfile profile = UserProfile(
    email: 'a@b.c',
    userUid: 'userUid',
    username: 'username',
  );

  tearDownAll(() {
    settingsBloc.close();
    profileBloc.close();
  });

  group('initialState', () {
    test(
      'should return a state with error when settings not present',
      () async {
        when(settingsBloc.state).thenReturn(EmptySettingsState());

        final EditSettingsBloc editSettingsBloc = EditSettingsBloc(
          settingsFacade: settingsFacade,
          settingsBloc: settingsBloc,
          profileBloc: profileBloc,
        );

        expect(editSettingsBloc.initialState.settingsStateNotComplete, isTrue);

        editSettingsBloc.close();
      },
    );

    test(
      'should return a state with no error and correct theme when settings are present',
      () async {
        when(settingsBloc.state).thenReturn(CompleteSettingsState(settings));

        final EditSettingsBloc editSettingsBloc = EditSettingsBloc(
          settingsFacade: settingsFacade,
          settingsBloc: settingsBloc,
          profileBloc: profileBloc,
        );

        expect(editSettingsBloc.initialState.settingsStateNotComplete, isFalse);
        expect(
          editSettingsBloc.initialState.theme,
          equals(CollectioTheme.LIGHT),
        );

        editSettingsBloc.close();
      },
    );
  });

  group('change theme', () {
    blocTest(
      'should yield nothing when profile state is not complete and changing theme',
      build: () async {
        when(profileBloc.state).thenReturn(EmptyProfileState());
        return EditSettingsBloc(
          settingsFacade: settingsFacade,
          settingsBloc: settingsBloc,
          profileBloc: profileBloc,
        );
      },
      act: (EditSettingsBloc bloc) async =>
          bloc.add(ChangeThemeEditSettingsEvent(CollectioTheme.DARK)),
      expect: [],
    );

    blocTest(
      'should call SettingsFacade when profile complete and changing theme',
      build: () async {
        when(profileBloc.state).thenReturn(CompleteProfileState(profile));
        when(settingsFacade.updateSettings(
                username: anyNamed('username'), settings: anyNamed('settings')))
            .thenAnswer((_) async => null);
        return EditSettingsBloc(
          settingsFacade: settingsFacade,
          settingsBloc: settingsBloc,
          profileBloc: profileBloc,
        );
      },
      act: (EditSettingsBloc bloc) async =>
          bloc.add(ChangeThemeEditSettingsEvent(CollectioTheme.DARK)),
      verify: (_) async => verify(
        settingsFacade.updateSettings(
          username: profile.username,
          settings: Settings(
            theme: CollectioTheme.DARK,
            language: Language.en,
          ),
        ),
      ).called(1),
    );

    blocTest(
      'should yield state with new theme when profile state is complete and changing theme',
      build: () async {
        when(profileBloc.state).thenReturn(CompleteProfileState(profile));
        return EditSettingsBloc(
          settingsFacade: settingsFacade,
          settingsBloc: settingsBloc,
          profileBloc: profileBloc,
        );
      },
      act: (EditSettingsBloc bloc) async =>
          bloc.add(ChangeThemeEditSettingsEvent(CollectioTheme.DARK)),
      expect: [GeneralEditSettingsState(theme: CollectioTheme.DARK)],
    );

    blocTest(
      'should yield correct two states when profile state is complete, changing theme, and saving successful',
      build: () async {
        when(profileBloc.state).thenReturn(CompleteProfileState(profile));
        when(settingsFacade.updateSettings(
                username: anyNamed('username'), settings: anyNamed('settings')))
            .thenAnswer((_) async => Right(null));
        return EditSettingsBloc(
          settingsFacade: settingsFacade,
          settingsBloc: settingsBloc,
          profileBloc: profileBloc,
        );
      },
      act: (EditSettingsBloc bloc) async =>
          bloc.add(ChangeThemeEditSettingsEvent(CollectioTheme.DARK)),
      expect: [
        GeneralEditSettingsState(theme: CollectioTheme.DARK),
        GeneralEditSettingsState(
          theme: CollectioTheme.DARK,
          updateSuccessful: true,
        ),
      ],
    );

    blocTest(
      'should yield correct two states when profile state is complete, changing theme, and saving unsuccessful',
      build: () async {
        when(profileBloc.state).thenReturn(CompleteProfileState(profile));
        when(settingsFacade.updateSettings(
                username: anyNamed('username'), settings: anyNamed('settings')))
            .thenAnswer((_) async => Left(DataFailure()));
        return EditSettingsBloc(
          settingsFacade: settingsFacade,
          settingsBloc: settingsBloc,
          profileBloc: profileBloc,
        );
      },
      act: (EditSettingsBloc bloc) async =>
          bloc.add(ChangeThemeEditSettingsEvent(CollectioTheme.DARK)),
      expect: [
        GeneralEditSettingsState(theme: CollectioTheme.DARK),
        GeneralEditSettingsState(
          theme: CollectioTheme.LIGHT,
          updateSuccessful: false,
        ),
      ],
    );
  });

  group('change language', () {
    blocTest(
      'should yield nothing when profile state is not complete and changing language',
      build: () async {
        when(profileBloc.state).thenReturn(EmptyProfileState());
        return EditSettingsBloc(
          settingsFacade: settingsFacade,
          settingsBloc: settingsBloc,
          profileBloc: profileBloc,
        );
      },
      act: (EditSettingsBloc bloc) async =>
          bloc.add(ChangeLanguageEditSettingsEvent(Language.sl)),
      expect: [],
    );

    blocTest(
      'should call SettingsFacade when profile complete and changing language',
      build: () async {
        when(profileBloc.state).thenReturn(CompleteProfileState(profile));
        when(settingsFacade.updateSettings(
                username: anyNamed('username'), settings: anyNamed('settings')))
            .thenAnswer((_) async => null);
        return EditSettingsBloc(
          settingsFacade: settingsFacade,
          settingsBloc: settingsBloc,
          profileBloc: profileBloc,
        );
      },
      act: (EditSettingsBloc bloc) async =>
          bloc.add(ChangeLanguageEditSettingsEvent(Language.sl)),
      verify: (_) async => verify(
        settingsFacade.updateSettings(
          username: profile.username,
          settings: Settings(
            theme: CollectioTheme.LIGHT,
            language: Language.sl,
          ),
        ),
      ).called(1),
    );

    blocTest(
      'should yield state with new theme when profile state is complete and changing language',
      build: () async {
        when(profileBloc.state).thenReturn(CompleteProfileState(profile));
        return EditSettingsBloc(
          settingsFacade: settingsFacade,
          settingsBloc: settingsBloc,
          profileBloc: profileBloc,
        );
      },
      act: (EditSettingsBloc bloc) async =>
          bloc.add(ChangeLanguageEditSettingsEvent(Language.sl)),
      expect: [GeneralEditSettingsState(language: Language.sl)],
    );

    blocTest(
      'should yield correct two states when profile state is complete, changing language, and saving successful',
      build: () async {
        when(profileBloc.state).thenReturn(CompleteProfileState(profile));
        when(settingsFacade.updateSettings(
                username: anyNamed('username'), settings: anyNamed('settings')))
            .thenAnswer((_) async => Right(null));
        return EditSettingsBloc(
          settingsFacade: settingsFacade,
          settingsBloc: settingsBloc,
          profileBloc: profileBloc,
        );
      },
      act: (EditSettingsBloc bloc) async =>
          bloc.add(ChangeLanguageEditSettingsEvent(Language.sl)),
      expect: [
        GeneralEditSettingsState(language: Language.sl),
        GeneralEditSettingsState(
          language: Language.sl,
          updateSuccessful: true,
        ),
      ],
    );

    blocTest(
      'should yield correct two states when profile state is complete, changing language, and saving unsuccessful',
      build: () async {
        when(profileBloc.state).thenReturn(CompleteProfileState(profile));
        when(settingsFacade.updateSettings(
                username: anyNamed('username'), settings: anyNamed('settings')))
            .thenAnswer((_) async => Left(DataFailure()));
        return EditSettingsBloc(
          settingsFacade: settingsFacade,
          settingsBloc: settingsBloc,
          profileBloc: profileBloc,
        );
      },
      act: (EditSettingsBloc bloc) async =>
          bloc.add(ChangeLanguageEditSettingsEvent(Language.sl)),
      expect: [
        GeneralEditSettingsState(language: Language.sl),
        GeneralEditSettingsState(
          language: Language.en,
          updateSuccessful: false,
        ),
      ],
    );
  });
}
