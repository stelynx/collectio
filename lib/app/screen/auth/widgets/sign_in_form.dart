import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../util/error/auth_failure.dart';
import '../../../../util/error/validation_failure.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/sign_in_bloc.dart';
import '../../../routes/routes.dart';
import '../../../widgets/collectio_button.dart';
import '../../../widgets/collectio_text_field.dart';

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
              if (!state.isRegistering) {
                context.bloc<AuthBloc>().add(CheckStatusAuthEvent());
                Navigator.of(context)
                    .pushReplacementNamed(Routes.myCollections);
              }
            },
          );
        }
      },
      builder: (context, state) {
        return Center(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              // Email field
              CollectioTextField(
                onChanged: (String value) => context
                    .bloc<SignInBloc>()
                    .add(EmailChangedSignInEvent(email: value)),
                labelText: 'Email',
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

              const SizedBox(height: 10),

              // Password field
              CollectioTextField(
                obscureText: true,
                onChanged: (String value) => context
                    .bloc<SignInBloc>()
                    .add(PasswordChangedSignInEvent(password: value)),
                labelText: 'Password',
                errorText: state.showErrorMessages && !state.password.isValid()
                    ? 'Invalid password'
                    : null,
              ),

              const SizedBox(height: 10),

              if (state.isRegistering) ...[
                // Username field
                CollectioTextField(
                  onChanged: (String value) => context
                      .bloc<SignInBloc>()
                      .add(UsernameChangedSignInEvent(username: value)),
                  labelText: 'Username',
                  errorText: state.showErrorMessages &&
                          !state.username.isValid()
                      ? state.username.value.fold(
                          (ValidationFailure failure) => failure
                                  is UsernameTooShortValidationFailure
                              ? 'Username too short'
                              : 'Invalid username. Use only alphanumeric values!',
                          (_) => null)
                      : null,
                ),

                SizedBox(height: 10),
              ],

              // Sign in with email and password button
              CollectioButton(
                onPressed: () => context
                    .bloc<SignInBloc>()
                    .add(SignInWithEmailAndPasswordSignInEvent()),
                child: const Text('Sign in'),
              ),

              const SizedBox(height: 10),

              // Sign in with email and password button
              CollectioButton(
                onPressed: () {
                  if (state.isRegistering && state.username.isValid()) {
                    context
                        .bloc<SignInBloc>()
                        .add(RegisterWithEmailAndPasswordSignInEvent());
                  } else {
                    context
                        .bloc<SignInBloc>()
                        .add(CheckIfEmailExistsSignInEvent());
                  }
                },
                child: const Text('Register'),
              ),

              // Linear progress indicator if submitting the form
              if (state.isSubmitting) ...[
                const SizedBox(height: 10),
                const CircularProgressIndicator(),
              ],
            ],
          ),
        );
      },
    );
  }
}
