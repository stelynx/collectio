part of 'edit_profile_bloc.dart';

abstract class EditProfileState extends Equatable {
  final Name firstName;
  final Name lastName;
  final Country country;
  final Photo profileImage;
  final String oldImageUrl;
  final bool isSubmitting;
  final Either<DataFailure, void> dataFailure;

  EditProfileState({
    this.firstName,
    this.lastName,
    this.country,
    this.profileImage,
    this.oldImageUrl,
    this.isSubmitting,
    this.dataFailure,
  });

  EditProfileState copyWith({
    Name firstName,
    Name lastName,
    Country country,
    Photo profileImage,
    bool isSubmitting,
    Either<DataFailure, void> dataFailure,
    bool overrideDataFailure,
  }) =>
      GeneralEditProfileState(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        country: country ?? this.country,
        profileImage: profileImage ?? this.profileImage,
        oldImageUrl: this.oldImageUrl,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        dataFailure: overrideDataFailure == true || dataFailure != null
            ? dataFailure
            : this.dataFailure,
      );

  @override
  List<Object> get props => [
        firstName,
        lastName,
        country,
        profileImage,
        oldImageUrl,
        isSubmitting,
        dataFailure
      ];
}

class InitialEditProfileState extends EditProfileState {
  InitialEditProfileState({
    String firstName,
    String lastName,
    Country country,
    String oldImageUrl,
  }) : super(
          firstName: Name(firstName ?? ''),
          lastName: Name(lastName ?? ''),
          country: country,
          profileImage: null,
          oldImageUrl: oldImageUrl,
          isSubmitting: false,
          dataFailure: null,
        );
}

class GeneralEditProfileState extends EditProfileState {
  GeneralEditProfileState({
    Name firstName,
    Name lastName,
    Country country,
    Photo profileImage,
    String oldImageUrl,
    bool isSubmitting,
    Either<DataFailure, void> dataFailure,
  }) : super(
          firstName: firstName ?? Name(''),
          lastName: lastName ?? Name(''),
          country: country ?? null,
          profileImage: profileImage ?? Photo(null),
          oldImageUrl: oldImageUrl ?? null,
          isSubmitting: isSubmitting ?? false,
          dataFailure: dataFailure ?? null,
        );
}
