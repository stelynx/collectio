import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_bloc.dart';
import '../routes/routes.dart';

class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is InitialAuthState) {
        } else if (state is AuthenticatedAuthState) {
          Navigator.of(context).pushReplacementNamed(Routes.error,
              arguments: 'Not yet implemented');
        } else if (state is UnauthenticatedAuthState) {
          Navigator.of(context).pushReplacementNamed(Routes.signIn);
        }
      },
      child: _InitialScreenWidget(),
    );
  }
}

class _InitialScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
