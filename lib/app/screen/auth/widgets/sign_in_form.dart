import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../util/constant/translation.dart';
import '../../../../util/error/auth_failure.dart';
import '../../../../util/error/validation_failure.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/sign_in_bloc.dart';
import '../../../config/app_localizations.dart';
import '../../../routes/routes.dart';
import '../../../theme/style.dart';
import '../../../widgets/collectio_button.dart';
import '../../../widgets/collectio_text_field.dart';
import '../../../widgets/failure_text.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state.authFailure != null &&
            state.authFailure.isRight() &&
            !state.isRegistering) {
          context.bloc<AuthBloc>().add(CheckStatusAuthEvent());
          Navigator.of(context).pushReplacementNamed(Routes.myCollections);
        }
      },
      builder: (context, state) {
        return ListView(
          shrinkWrap: true,
          padding: CollectioStyle.screenPadding,
          children: <Widget>[
            // Email field
            CollectioTextField(
              onChanged: (String value) => context
                  .bloc<SignInBloc>()
                  .add(EmailChangedSignInEvent(email: value)),
              labelText:
                  AppLocalizations.of(context).translate(Translation.email),
              errorText: state.showErrorMessages && !state.email.isValid()
                  ? state.email.value.fold(
                      (ValidationFailure failure) =>
                          failure is EmailEmptyValidationFailure
                              ? AppLocalizations.of(context)
                                  .translate(Translation.fillInEmail)
                              : AppLocalizations.of(context)
                                  .translate(Translation.invalidEmail),
                      (_) => null,
                    )
                  : null,
            ),

            CollectioStyle.itemSplitter,

            // Password field
            CollectioTextField(
              obscureText: true,
              onChanged: (String value) => context
                  .bloc<SignInBloc>()
                  .add(PasswordChangedSignInEvent(password: value)),
              labelText:
                  AppLocalizations.of(context).translate(Translation.password),
              errorText: state.showErrorMessages && !state.password.isValid()
                  ? AppLocalizations.of(context)
                      .translate(Translation.invalidPassword)
                  : null,
            ),

            CollectioStyle.itemSplitter,

            if (state.isRegistering) ...[
              // Username field
              CollectioTextField(
                onChanged: (String value) => context
                    .bloc<SignInBloc>()
                    .add(UsernameChangedSignInEvent(username: value)),
                labelText: AppLocalizations.of(context)
                    .translate(Translation.username),
                errorText: state.showErrorMessages && !state.username.isValid()
                    ? state.username.value.fold(
                        (ValidationFailure failure) =>
                            failure is UsernameTooShortValidationFailure
                                ? AppLocalizations.of(context)
                                    .translate(Translation.usernameTooShort)
                                : AppLocalizations.of(context)
                                    .translate(Translation.invalidUsername),
                        (_) => null)
                    : null,
              ),

              CollectioStyle.itemSplitter,
            ],

            if (state.authFailure != null && state.authFailure.isLeft()) ...[
              CollectioStyle.itemSplitter,
              state.authFailure.fold(
                  (AuthFailure failure) => FailureText(failure.message), null),
              CollectioStyle.itemSplitter,
              CollectioStyle.itemSplitter,
            ],

            // Sign in with email and password button
            CollectioButton(
              onPressed: () => context
                  .bloc<SignInBloc>()
                  .add(SignInWithEmailAndPasswordSignInEvent()),
              text: AppLocalizations.of(context).translate(Translation.signIn),
              isPrimary: true,
            ),

            CollectioStyle.itemSplitter,

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
              text:
                  AppLocalizations.of(context).translate(Translation.register),
              isPrimary: true,
            ),

            // Linear progress indicator if submitting the form
            if (state.isSubmitting) ...[
              CollectioStyle.itemSplitter,
              const Center(child: const CircularProgressIndicator()),
            ],
          ],
        );
      },
    );
  }
}
