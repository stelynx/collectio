import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:injectable/injectable.dart';

import 'app/bloc/app_configuration/app_configuration_bloc.dart';
import 'app/bloc/auth/auth_bloc.dart';
import 'app/bloc/settings/settings_bloc.dart';
import 'app/config/app_localizations.dart';
import 'app/routes/router.dart';
import 'app/routes/routes.dart';
import 'app/theme/theme.dart';
import 'util/injection/injection.dart';

void main() {
  configureInjection(Environment.prod);
  runApp(CollectioApp());
}

class CollectioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthBloc>()..add(CheckStatusAuthEvent()),
        ),
        BlocProvider(
          create: (_) => getIt<SettingsBloc>(),
        ),
      ],
      child: BlocBuilder<AppConfigurationBloc, AppConfigurationState>(
        bloc: getIt<AppConfigurationBloc>(),
        builder: (
          BuildContext context,
          AppConfigurationState appConfigurationState,
        ) =>
            MaterialApp(
          title: 'Stelynx Collectio',
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.initial,
          onGenerateRoute: Router.onGenerateRoute,
          theme: CollectioThemeManager.getTheme(appConfigurationState.theme),
          locale: AppLocalizations.localeFromLangugage(
            appConfigurationState.language,
          ),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }
}
