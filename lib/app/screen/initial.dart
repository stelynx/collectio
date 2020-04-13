import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/navigation/navigation_bloc.dart';

class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is InitialAuthState) {
        } else if (state is AuthenticatedAuthState) {
          context
              .bloc<NavigationBloc>()
              .add(GoToHomeScreenAfterSignInNavigationEvent());
        } else if (state is UnauthenticatedAuthState) {
          context.bloc<NavigationBloc>().add(GoToSignInScreenNavigationEvent());
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
