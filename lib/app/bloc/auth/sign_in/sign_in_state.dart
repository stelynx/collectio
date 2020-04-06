part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  final Email email;
  final Password password;
  final bool showErrorMessages;
  final bool isSubmitting;
  final Either<AuthFailure, void> authFailure;

  SignInState({
    @required this.email,
    @required this.password,
    @required this.showErrorMessages,
    @required this.isSubmitting,
    @required this.authFailure,
  });

  SignInState copyWith({
    Email email,
    Password password,
    bool showErrorMessages,
    bool isSubmitting,
    Either<AuthFailure, void> authFailure,
  }) =>
      GeneralSignInState(
        email: email ?? this.email,
        password: password ?? this.password,
        showErrorMessages: showErrorMessages ?? this.showErrorMessages,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        authFailure: authFailure ?? this.authFailure,
      );

  @override
  List<Object> get props =>
      [email, password, showErrorMessages, isSubmitting, authFailure];
}

class InitialSignInState extends SignInState {
  InitialSignInState()
      : super(
          email: Email(''),
          password: Password(''),
          showErrorMessages: false,
          isSubmitting: false,
          authFailure: null,
        );
}

class GeneralSignInState extends SignInState {
  GeneralSignInState({
    @required Email email,
    @required Password password,
    @required bool showErrorMessages,
    @required bool isSubmitting,
    @required Either<AuthFailure, void> authFailure,
  }) : super(
          email: email,
          password: password,
          showErrorMessages: showErrorMessages,
          isSubmitting: isSubmitting,
          authFailure: authFailure,
        );
}
