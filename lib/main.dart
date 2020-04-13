import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'app/bloc/auth/auth_bloc.dart';
import 'app/routes/router.dart';
import 'app/routes/routes.dart';
import 'util/injection/injection.dart';

void main() {
  configureInjection(Environment.prod);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthBloc>()..add(CheckStatusAuthEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Stelynx Collectio',
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.initial,
        onGenerateRoute: Router.onGenerateRoute,
      ),
    );
  }
}
