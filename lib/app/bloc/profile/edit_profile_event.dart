part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent {
  const EditProfileEvent();
}

class FirstNameChangedEditProfileEvent extends EditProfileEvent {
  final String firstName;

  const FirstNameChangedEditProfileEvent(this.firstName);
}

class LastNameChangedEditProfileEvent extends EditProfileEvent {
  final String lastName;

  const LastNameChangedEditProfileEvent(this.lastName);
}

class CountryChangedEditProfileEvent extends EditProfileEvent {
  final Country country;

  const CountryChangedEditProfileEvent(this.country);
}

class ImageChangedEditProfileEvent extends EditProfileEvent {
  final File photo;

  const ImageChangedEditProfileEvent(this.photo);
}

class SubmitEditProfileEvent extends EditProfileEvent {}

class ResetEditProfileEvent extends EditProfileEvent {}
