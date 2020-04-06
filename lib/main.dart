import 'package:collectio/app/routes/router.dart';
import 'package:collectio/facade/auth/firebase/firebase_auth_facade.dart';
import 'package:collectio/service/firebase/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/bloc/auth/auth_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            authFacade: FirebaseAuthFacade(
              authService: FirebaseAuthService(
                firebaseAuth: FirebaseAuth.instance,
              ),
            ),
          )..add(CheckStatusAuthEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Stelynx Collectio',
        debugShowCheckedModeBanner: false,
        initialRoute: Router.initial,
        onGenerateRoute: Router.onGenerateRoute,
      ),
    );
  }
}
