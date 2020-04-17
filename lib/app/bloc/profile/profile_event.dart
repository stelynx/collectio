part of 'profile_bloc.dart';

abstract class ProfileEvent {
  const ProfileEvent();
}

class GetUserProfileEvent extends ProfileEvent {
  final String userUid;

  const GetUserProfileEvent({this.userUid});
}

class AddUserProfileEvent extends ProfileEvent {
  final UserProfile userProfile;

  const AddUserProfileEvent(this.userProfile);
}
