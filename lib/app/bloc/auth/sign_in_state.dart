part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  final Email email;
  final Password password;
  final Username username;
  final bool showErrorMessages;
  final bool isSubmitting;
  final bool isRegistering;
  final Either<AuthFailure, void> authFailure;

  SignInState({
    @required this.email,
    @required this.password,
    @required this.username,
    @required this.showErrorMessages,
    @required this.isSubmitting,
    @required this.isRegistering,
    @required this.authFailure,
  });

  SignInState copyWith({
    Email email,
    Password password,
    Username username,
    bool showErrorMessages,
    bool isSubmitting,
    bool isRegistering,
    Either<AuthFailure, void> authFailure,
    bool overrideAuthFailure = false,
  }) =>
      GeneralSignInState(
        email: email ?? this.email,
        password: password ?? this.password,
        username: username ?? this.username,
        showErrorMessages: showErrorMessages ?? this.showErrorMessages,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isRegistering: isRegistering ?? this.isRegistering,
        authFailure: overrideAuthFailure
            ? authFailure
            : (authFailure ?? this.authFailure),
      );

  @override
  List<Object> get props => [
        email,
        password,
        username,
        showErrorMessages,
        isSubmitting,
        isRegistering,
        authFailure
      ];
}

class InitialSignInState extends SignInState {
  InitialSignInState()
      : super(
          email: Email(''),
          password: Password(''),
          username: Username(''),
          showErrorMessages: false,
          isSubmitting: false,
          isRegistering: false,
          authFailure: null,
        );
}

class GeneralSignInState extends SignInState {
  GeneralSignInState({
    Email email,
    Password password,
    Username username,
    bool showErrorMessages,
    bool isSubmitting,
    bool isRegistering,
    Either<AuthFailure, void> authFailure,
  }) : super(
          email: email ?? Email(''),
          password: password ?? Password(''),
          username: username ?? Username(''),
          showErrorMessages: showErrorMessages ?? false,
          isSubmitting: isSubmitting ?? false,
          isRegistering: isRegistering ?? false,
          authFailure: authFailure ?? null,
        );
}
