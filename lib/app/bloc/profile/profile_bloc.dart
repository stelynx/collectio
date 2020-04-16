import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import '../../../facade/profile/profile_facade.dart';
import '../../../model/user_profile.dart';
import '../../../util/error/data_failure.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@prod
@lazySingleton
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileFacade _profileFacade;

  ProfileBloc({@required ProfileFacade profileFacade})
      : _profileFacade = profileFacade;

  ProfileFacade get profileFacade => _profileFacade;

  @override
  ProfileState get initialState => InitialProfileState();

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    yield LoadingProfileState();

    if (event is GetUserProfileEvent) {
      Either<DataFailure, UserProfile> profileOrFailure =
          await _profileFacade.getUserProfile(username: event.username);

      yield profileOrFailure.fold(
        (DataFailure failure) => ErrorProfileState(failure),
        (UserProfile profile) => CompleteProfileState(profile),
      );
    } else if (event is AddUserProfileEvent) {
      Either<DataFailure, void> nullOrFailure =
          await _profileFacade.addUserProfile(userProfile: event.userProfile);

      yield nullOrFailure.fold(
        (DataFailure failure) => ErrorProfileState(failure),
        (_) => CompleteProfileState(event.userProfile),
      );
    }
  }
}

@test
@lazySingleton
@RegisterAs(ProfileBloc)
class MockedProfileBloc extends Mock implements ProfileBloc {}
