import 'package:bloc_test/bloc_test.dart';
import 'package:collectio/app/bloc/profile/edit_profile_bloc.dart';
import 'package:collectio/app/bloc/profile/profile_bloc.dart';
import 'package:collectio/facade/profile/profile_facade.dart';
import 'package:collectio/model/user_profile.dart';
import 'package:collectio/model/value_object/name.dart';
import 'package:collectio/model/value_object/photo.dart';
import 'package:collectio/util/constant/country.dart';
import 'package:collectio/util/error/data_failure.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;
import 'package:mockito/mockito.dart';

import '../../../mocks.dart';

void main() {
  configureInjection(Environment.test);

  final ProfileBloc mockedProfileBloc = getIt<ProfileBloc>();
  final ProfileFacade mockedProfileFacade = getIt<ProfileFacade>();

  final MockedFile mockedFile = MockedFile();
  final UserProfile userProfile = UserProfile(
    email: 'email@b.c',
    userUid: 'userUid',
    username: 'username',
  );
  final CompleteProfileState completeProfileState =
      CompleteProfileState(userProfile);

  tearDownAll(() {
    mockedProfileBloc.close();
  });

  test(
    'should configure initial state if profile state is complete',
    () async {
      when(mockedProfileBloc.state).thenReturn(completeProfileState);
      final editProfileBloc = EditProfileBloc(
          profileFacade: mockedProfileFacade, profileBloc: mockedProfileBloc);

      expect(
          editProfileBloc.initialState,
          equals(InitialEditProfileState(
            firstName: userProfile.firstName,
            lastName: userProfile.lastName,
            country: userProfile.country,
            oldImageUrl: userProfile.profileImg,
          )));

      editProfileBloc.close();
    },
  );

  test(
    'should return blank initial state if profile state is not complete',
    () async {
      when(mockedProfileBloc.state).thenReturn(null);
      final editProfileBloc = EditProfileBloc(
          profileFacade: mockedProfileFacade, profileBloc: mockedProfileBloc);

      expect(editProfileBloc.initialState, equals(InitialEditProfileState()));

      editProfileBloc.close();
    },
  );

  blocTest(
    'should update first name on FirstNameChanged',
    build: () async {
      when(mockedProfileBloc.state).thenReturn(null);
      return EditProfileBloc(
          profileFacade: mockedProfileFacade, profileBloc: mockedProfileBloc);
    },
    act: (EditProfileBloc bloc) async =>
        bloc.add(FirstNameChangedEditProfileEvent('firstName')),
    expect: [
      GeneralEditProfileState(firstName: Name('firstName')),
    ],
  );

  blocTest(
    'should update last name on LastNameChanged',
    build: () async {
      when(mockedProfileBloc.state).thenReturn(null);
      return EditProfileBloc(
          profileFacade: mockedProfileFacade, profileBloc: mockedProfileBloc);
    },
    act: (EditProfileBloc bloc) async =>
        bloc.add(LastNameChangedEditProfileEvent('lastName')),
    expect: [
      GeneralEditProfileState(lastName: Name('lastName')),
    ],
  );

  blocTest(
    'should update country on CountryChanged',
    build: () async {
      when(mockedProfileBloc.state).thenReturn(null);
      return EditProfileBloc(
          profileFacade: mockedProfileFacade, profileBloc: mockedProfileBloc);
    },
    act: (EditProfileBloc bloc) async =>
        bloc.add(CountryChangedEditProfileEvent(Country.DE)),
    expect: [
      GeneralEditProfileState(country: Country.DE),
    ],
  );

  blocTest(
    'should update profile image on ImageChanged',
    build: () async {
      when(mockedProfileBloc.state).thenReturn(null);
      return EditProfileBloc(
          profileFacade: mockedProfileFacade, profileBloc: mockedProfileBloc);
    },
    act: (EditProfileBloc bloc) async =>
        bloc.add(ImageChangedEditProfileEvent(mockedFile)),
    expect: [
      GeneralEditProfileState(profileImage: Photo(mockedFile)),
    ],
  );

  blocTest(
    'should reset the state to initial on Reset',
    build: () async {
      when(mockedProfileBloc.state).thenReturn(null);
      return EditProfileBloc(
          profileFacade: mockedProfileFacade, profileBloc: mockedProfileBloc);
    },
    act: (EditProfileBloc bloc) async => bloc
      ..add(ImageChangedEditProfileEvent(mockedFile))
      ..add(ResetEditProfileEvent()),
    expect: [
      GeneralEditProfileState(profileImage: Photo(mockedFile)),
      InitialEditProfileState(),
    ],
  );

  blocTest(
    'should set data failure on successful update',
    build: () async {
      when(mockedProfileBloc.state).thenReturn(completeProfileState);
      when(mockedProfileFacade.editUserProfile(
              userProfile: anyNamed('userProfile'),
              profileImage: anyNamed('profileImage')))
          .thenAnswer((_) async => Right(null));
      return EditProfileBloc(
          profileFacade: mockedProfileFacade, profileBloc: mockedProfileBloc);
    },
    act: (EditProfileBloc bloc) async => bloc.add(SubmitEditProfileEvent()),
    expect: [
      GeneralEditProfileState(isSubmitting: true),
      GeneralEditProfileState(
        isSubmitting: false,
        dataFailure: Right(null),
      ),
    ],
  );

  blocTest(
    'should set data failure on unsuccessful update',
    build: () async {
      when(mockedProfileBloc.state).thenReturn(completeProfileState);
      when(mockedProfileFacade.editUserProfile(
              userProfile: anyNamed('userProfile'),
              profileImage: anyNamed('profileImage')))
          .thenAnswer((_) async => Left(DataFailure()));
      return EditProfileBloc(
          profileFacade: mockedProfileFacade, profileBloc: mockedProfileBloc);
    },
    act: (EditProfileBloc bloc) async => bloc.add(SubmitEditProfileEvent()),
    expect: [
      GeneralEditProfileState(isSubmitting: true),
      GeneralEditProfileState(
        isSubmitting: false,
        dataFailure: Left(DataFailure()),
      ),
    ],
  );

  blocTest(
    'should do nothing on Submit if profile state is not complete',
    build: () async {
      when(mockedProfileBloc.state).thenReturn(null);
      return EditProfileBloc(
          profileFacade: mockedProfileFacade, profileBloc: mockedProfileBloc);
    },
    act: (EditProfileBloc bloc) async => bloc.add(SubmitEditProfileEvent()),
    expect: [],
  );
}
