import 'package:bloc_test/bloc_test.dart';
import 'package:collectio/app/bloc/app_configuration/app_configuration_bloc.dart';
import 'package:collectio/app/bloc/settings/settings_bloc.dart';
import 'package:collectio/model/settings.dart';
import 'package:collectio/util/constant/collectio_theme.dart';
import 'package:collectio/util/constant/language.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;
import 'package:mockito/mockito.dart';

import '../../../mocks.dart';

void main() {
  configureInjection(Environment.test);

  final Settings settings = Settings(
    theme: CollectioTheme.LIGHT,
    language: Language.en,
  );

  final SettingsBloc settingsBloc = getIt<SettingsBloc>();

  tearDownAll(() {
    settingsBloc.close();
  });

  blocTest(
    'should yield a state with selected theme and language',
    build: () async {
      when(settingsBloc.listen(any))
          .thenReturn(MockedStreamSubscription<SettingsState>());
      when(settingsBloc.state).thenReturn(CompleteSettingsState(settings));
      return AppConfigurationBloc(settingsBloc: settingsBloc);
    },
    act: (AppConfigurationBloc bloc) async =>
        bloc.add(ChangeAppConfigurationEvent(Settings(
      theme: CollectioTheme.LIGHT,
      language: Language.de,
    ))),
    expect: [
      AppConfigurationState(
        theme: CollectioTheme.LIGHT,
        language: Language.de,
      ),
    ],
  );

  test(
    'should set initial configuration to user\'s preferences when available',
    () async {
      when(settingsBloc.listen(any))
          .thenReturn(MockedStreamSubscription<SettingsState>());
      when(settingsBloc.state).thenReturn(CompleteSettingsState(settings));

      final AppConfigurationBloc themeBloc =
          AppConfigurationBloc(settingsBloc: settingsBloc);

      expect(
        themeBloc.state,
        equals(AppConfigurationState(
          theme: CollectioTheme.LIGHT,
          language: Language.en,
        )),
      );

      themeBloc.close();
    },
  );

  test(
    'should set initial configuration to defaults when no user\'s settings',
    () async {
      when(settingsBloc.listen(any))
          .thenReturn(MockedStreamSubscription<SettingsState>());
      when(settingsBloc.state).thenReturn(ErrorSettingsState());

      final AppConfigurationBloc themeBloc =
          AppConfigurationBloc(settingsBloc: settingsBloc);

      expect(
        themeBloc.state,
        equals(AppConfigurationState.fromSettings(Settings.defaults())),
      );

      themeBloc.close();
    },
  );
}
