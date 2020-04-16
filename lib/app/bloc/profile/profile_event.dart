part of 'profile_bloc.dart';

abstract class ProfileEvent {
  const ProfileEvent();
}

class GetUserProfileEvent extends ProfileEvent {
  final String username;

  const GetUserProfileEvent(this.username);
}

class AddUserProfileEvent extends ProfileEvent {
  final UserProfile userProfile;

  const AddUserProfileEvent(this.userProfile);
}
