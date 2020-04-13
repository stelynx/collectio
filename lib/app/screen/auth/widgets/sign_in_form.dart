import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../util/error/auth_failure.dart';
import '../../../../util/error/validation_failure.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/sign_in_bloc.dart';
import '../../../bloc/navigation/navigation_bloc.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state.authFailure != null) {
          state.authFailure.fold(
            (AuthFailure failure) {
              print(failure);
            },
            (_) {
              context
                  .bloc<NavigationBloc>()
                  .add(GoToHomeScreenAfterSignInNavigationEvent());
              context.bloc<AuthBloc>().add(CheckStatusAuthEvent());
            },
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: <Widget>[
                // Email field
                TextField(
                  autocorrect: false,
                  onChanged: (String value) => context
                      .bloc<SignInBloc>()
                      .add(EmailChangedSignInEvent(email: value)),
                  decoration: InputDecoration(
                    errorText: state.showErrorMessages && !state.email.isValid()
                        ? state.email.value.fold(
                            (ValidationFailure failure) =>
                                failure is EmailEmptyValidationFailure
                                    ? 'Fill in email'
                                    : 'Invalid email',
                            (_) => null,
                          )
                        : null,
                  ),
                ),

                const SizedBox(height: 10),

                // Password field
                TextField(
                  autocorrect: false,
                  obscureText: true,
                  onChanged: (String value) => context
                      .bloc<SignInBloc>()
                      .add(PasswordChangedSignInEvent(password: value)),
                  decoration: InputDecoration(
                    errorText:
                        state.showErrorMessages && !state.password.isValid()
                            ? 'Invalid password'
                            : null,
                  ),
                ),

                const SizedBox(height: 10),

                // Sign in with email and password button
                RaisedButton(
                  onPressed: () => context
                      .bloc<SignInBloc>()
                      .add(SignInWithEmailAndPasswordSignInEvent()),
                  child: const Text('Sign in'),
                ),

                const SizedBox(height: 10),

                // Sign in with email and password button
                RaisedButton(
                  onPressed: () => context
                      .bloc<SignInBloc>()
                      .add(RegisterWithEmailAndPasswordSignInEvent()),
                  child: const Text('Register'),
                ),

                // Linear progress indicator if submitting the form
                if (state.isSubmitting) ...[
                  const SizedBox(height: 10),
                  const LinearProgressIndicator(),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
