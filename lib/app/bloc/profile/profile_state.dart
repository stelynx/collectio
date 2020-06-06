part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class InitialProfileState extends ProfileState {}

class LoadingProfileState extends ProfileState {}

class CompleteProfileState extends ProfileState {
  final UserProfile userProfile;

  const CompleteProfileState(this.userProfile);

  @override
  List<Object> get props => [userProfile];
}

class EmptyProfileState extends ProfileState {}

class ErrorProfileState extends ProfileState {
  final DataFailure failure;

  const ErrorProfileState(this.failure);

  @override
  List<Object> get props => [failure];
}
