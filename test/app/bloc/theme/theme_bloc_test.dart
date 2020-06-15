import 'package:bloc_test/bloc_test.dart';
import 'package:collectio/app/bloc/settings/settings_bloc.dart';
import 'package:collectio/app/bloc/theme/theme_bloc.dart';
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
    'should yield a state with selected theme',
    build: () async {
      when(settingsBloc.listen(any))
          .thenReturn(MockedStreamSubscription<SettingsState>());
      when(settingsBloc.state).thenReturn(CompleteSettingsState(settings));
      return ThemeBloc(settingsBloc: settingsBloc);
    },
    act: (ThemeBloc bloc) async =>
        bloc.add(ChangeThemeEvent(CollectioTheme.LIGHT)),
    expect: [
      GeneralThemeState(themeType: CollectioTheme.LIGHT),
    ],
  );

  test(
    'should set initial theme to user\'s preferences when available',
    () async {
      when(settingsBloc.listen(any))
          .thenReturn(MockedStreamSubscription<SettingsState>());
      when(settingsBloc.state).thenReturn(CompleteSettingsState(settings));

      final ThemeBloc themeBloc = ThemeBloc(settingsBloc: settingsBloc);

      expect(
        themeBloc.state,
        equals(InitialThemeState(themeType: CollectioTheme.LIGHT)),
      );

      themeBloc.close();
    },
  );

  test(
    'should set initial theme to system theme when no user\'s settings',
    () async {
      when(settingsBloc.listen(any))
          .thenReturn(MockedStreamSubscription<SettingsState>());
      when(settingsBloc.state).thenReturn(ErrorSettingsState());

      final ThemeBloc themeBloc = ThemeBloc(settingsBloc: settingsBloc);

      expect(
        themeBloc.state,
        equals(InitialThemeState(themeType: CollectioTheme.SYSTEM)),
      );

      themeBloc.close();
    },
  );
}
