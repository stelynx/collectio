import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

import '../../../facade/profile/profile_facade.dart';
import '../../../model/user_profile.dart';
import '../../../model/value_object/name.dart';
import '../../../model/value_object/photo.dart';
import '../../../util/constant/country.dart';
import '../../../util/error/data_failure.dart';
import 'profile_bloc.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

@prod
@injectable
class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final ProfileFacade _profileFacade;
  final ProfileBloc _profileBloc;

  EditProfileBloc({
    @required ProfileFacade profileFacade,
    @required ProfileBloc profileBloc,
  })  : _profileFacade = profileFacade,
        _profileBloc = profileBloc;

  @override
  EditProfileState get initialState {
    if (_profileBloc.state is CompleteProfileState) {
      final UserProfile userProfile =
          (_profileBloc.state as CompleteProfileState).userProfile;

      return InitialEditProfileState(
        firstName: userProfile.firstName,
        lastName: userProfile.lastName,
        country: userProfile.country,
        oldImageUrl: userProfile.profileImg,
      );
    } else {
      return InitialEditProfileState();
    }
  }

  @override
  Stream<EditProfileState> mapEventToState(
    EditProfileEvent event,
  ) async* {
    if (event is FirstNameChangedEditProfileEvent) {
      yield state.copyWith(firstName: Name(event.firstName));
    } else if (event is LastNameChangedEditProfileEvent) {
      yield state.copyWith(lastName: Name(event.lastName));
    } else if (event is CountryChangedEditProfileEvent) {
      yield state.copyWith(country: event.country);
    } else if (event is ImageChangedEditProfileEvent) {
      yield state.copyWith(profileImage: Photo(event.photo));
    } else if (event is ResetEditProfileEvent) {
      yield initialState;
    } else if (event is SubmitEditProfileEvent) {
      if (_profileBloc.state is CompleteProfileState) {
        yield state.copyWith(isSubmitting: true);

        final UserProfile userProfile =
            (_profileBloc.state as CompleteProfileState).userProfile;
        userProfile.firstName = state.firstName.get() ?? '';
        userProfile.lastName = state.lastName.get() ?? '';
        userProfile.country = state.country;

        final Either<DataFailure, void> result =
            await _profileFacade.editUserProfile(
          userProfile: userProfile,
          profileImage: state.profileImage.get(),
        );

        if (result.isRight()) {
          yield state.copyWith(
            dataFailure: result,
            isSubmitting: false,
          );
        }
      }
    }
  }
}

@test
@injectable
@RegisterAs(EditProfileBloc)
class MockedEditProfileBloc extends Mock implements EditProfileBloc {}
