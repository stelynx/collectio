import 'package:collectio/app/bloc/auth/sign_in/sign_in_bloc.dart';
import 'package:collectio/app/screen/auth/widgets/sign_in_form.dart';
import 'package:collectio/facade/auth/firebase/firebase_auth_facade.dart';
import 'package:collectio/service/firebase/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SignInBloc(
          authFacade: FirebaseAuthFacade(
            authService: FirebaseAuthService(
              firebaseAuth: FirebaseAuth.instance,
            ),
          ),
        ),
        child: SignInForm(),
      ),
    );
  }
}
