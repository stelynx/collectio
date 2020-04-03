part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  final String email;
  final String password;
  final bool isSubmitting;
  final AuthFailure authFailure;

  SignInState({
    @required this.email,
    @required this.password,
    @required this.isSubmitting,
    @required this.authFailure,
  });

  SignInState copyWith({
    String email,
    String password,
    bool isSubmitting,
    Either<AuthFailure, void> authFailure,
  }) =>
      GeneralSignInState(
        email: email ?? this.email,
        password: password ?? this.password,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        authFailure: authFailure ?? this.authFailure,
      );

  @override
  List<Object> get props => [email, password, isSubmitting, authFailure];
}

class InitialSignInState extends SignInState {
  InitialSignInState()
      : super(email: '', password: '', isSubmitting: false, authFailure: null);
}

class GeneralSignInState extends SignInState {
  GeneralSignInState({
    @required String email,
    @required String password,
    @required bool isSubmitting,
    @required AuthFailure authFailure,
  }) : super(
          email: email,
          password: password,
          isSubmitting: isSubmitting,
          authFailure: authFailure,
        );
}
