import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'app/bloc/auth/auth_bloc.dart';
import 'app/bloc/theme/theme_bloc.dart';
import 'app/routes/router.dart';
import 'app/routes/routes.dart';
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
          create: (_) => getIt<ThemeBloc>(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (BuildContext context, ThemeState themeState) => MaterialApp(
          title: 'Stelynx Collectio',
          debugShowCheckedModeBanner: false,
          theme: themeState.theme,
          initialRoute: Routes.initial,
          onGenerateRoute: Router.onGenerateRoute,
        ),
      ),
    );
  }
}
