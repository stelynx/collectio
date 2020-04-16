import 'package:bloc_test/bloc_test.dart';
import 'package:collectio/app/bloc/profile/profile_bloc.dart';
import 'package:collectio/facade/profile/profile_facade.dart';
import 'package:collectio/model/user_profile.dart';
import 'package:collectio/util/error/data_failure.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;
import 'package:mockito/mockito.dart';

void main() {
  configureInjection(Environment.test);

  ProfileFacade mockedProfileFacade = getIt<ProfileFacade>();

  final UserProfile userProfile = UserProfile(
    email: 'email',
    userUid: 'userUid',
    username: 'username',
  );

  group('getUserProfile', () {
    blocTest(
      'should yield Loading and Complete on success',
      build: () async {
        when(mockedProfileFacade.getUserProfile(username: anyNamed('username')))
            .thenAnswer((_) async => Right(userProfile));
        return ProfileBloc(profileFacade: mockedProfileFacade);
      },
      act: (ProfileBloc bloc) async =>
          bloc.add(GetUserProfileEvent(userProfile.username)),
      expect: [LoadingProfileState(), CompleteProfileState(userProfile)],
    );

    blocTest(
      'should yield Loading and Error on failure',
      build: () async {
        when(mockedProfileFacade.getUserProfile(username: anyNamed('username')))
            .thenAnswer((_) async => Left(DataFailure()));
        return ProfileBloc(profileFacade: mockedProfileFacade);
      },
      act: (ProfileBloc bloc) async =>
          bloc.add(GetUserProfileEvent(userProfile.username)),
      expect: [LoadingProfileState(), ErrorProfileState(DataFailure())],
    );
  });

  group('addUserProfile', () {
    blocTest(
      'should yield Loading and Complete on success',
      build: () async {
        when(mockedProfileFacade.addUserProfile(
                userProfile: anyNamed('userProfile')))
            .thenAnswer((_) async => Right(null));
        return ProfileBloc(profileFacade: mockedProfileFacade);
      },
      act: (ProfileBloc bloc) async =>
          bloc.add(AddUserProfileEvent(userProfile)),
      expect: [LoadingProfileState(), CompleteProfileState(userProfile)],
    );

    blocTest(
      'should yield Loading and Error on failure',
      build: () async {
        when(mockedProfileFacade.addUserProfile(
                userProfile: anyNamed('userProfile')))
            .thenAnswer((_) async => Left(DataFailure()));
        return ProfileBloc(profileFacade: mockedProfileFacade);
      },
      act: (ProfileBloc bloc) async =>
          bloc.add(AddUserProfileEvent(userProfile)),
      expect: [LoadingProfileState(), ErrorProfileState(DataFailure())],
    );
  });
}
