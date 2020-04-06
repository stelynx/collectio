import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../facade/auth/firebase/firebase_auth_facade.dart';
import '../../../service/firebase/firebase_auth_service.dart';
import '../../bloc/auth/sign_in_bloc.dart';
import 'widgets/sign_in_form.dart';

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
