import 'package:bloc_test/bloc_test.dart';
import 'package:collectio/app/bloc/auth/auth_bloc.dart';
import 'package:collectio/app/bloc/profile/profile_bloc.dart';
import 'package:collectio/facade/profile/profile_facade.dart';
import 'package:collectio/model/user_profile.dart';
import 'package:collectio/util/error/data_failure.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;
import 'package:mockito/mockito.dart';

import '../../../mocks.dart';

void main() {
  configureInjection(Environment.test);

  ProfileFacade mockedProfileFacade = getIt<ProfileFacade>();
  MockedAuthBloc mockedAuthBloc = getIt<AuthBloc>();

  tearDownAll(() {
    mockedAuthBloc.close();
  });

  final UserProfile userProfile = UserProfile(
    email: 'email',
    userUid: 'userUid',
    username: 'username',
  );

  group('getUserProfile', () {
    blocTest(
      'should yield Loading and Complete on success',
      build: () async {
        when(mockedAuthBloc.listen(any)).thenReturn(MockedStreamSubscription());
        when(mockedProfileFacade.getUserProfileByUserUid(
                userUid: anyNamed('userUid')))
            .thenAnswer((_) async => Right(userProfile));
        return ProfileBloc(
          profileFacade: mockedProfileFacade,
          authBloc: mockedAuthBloc,
        );
      },
      act: (ProfileBloc bloc) async =>
          bloc.add(GetUserProfileEvent(userUid: userProfile.userUid)),
      expect: [LoadingProfileState(), CompleteProfileState(userProfile)],
    );

    blocTest(
      'should yield Loading and Error on failure',
      build: () async {
        when(mockedAuthBloc.listen(any)).thenReturn(MockedStreamSubscription());
        when(mockedProfileFacade.getUserProfileByUserUid(
                userUid: anyNamed('userUid')))
            .thenAnswer((_) async => Left(DataFailure()));
        return ProfileBloc(
            profileFacade: mockedProfileFacade, authBloc: mockedAuthBloc);
      },
      act: (ProfileBloc bloc) async =>
          bloc.add(GetUserProfileEvent(userUid: userProfile.userUid)),
      expect: [LoadingProfileState(), ErrorProfileState(DataFailure())],
    );
  });

  group('addUserProfile', () {
    blocTest(
      'should yield Loading and Complete on success',
      build: () async {
        when(mockedAuthBloc.listen(any)).thenReturn(MockedStreamSubscription());
        when(mockedProfileFacade.addUserProfile(
                userProfile: anyNamed('userProfile')))
            .thenAnswer((_) async => Right(null));
        return ProfileBloc(
          profileFacade: mockedProfileFacade,
          authBloc: mockedAuthBloc,
        );
      },
      act: (ProfileBloc bloc) async =>
          bloc.add(AddUserProfileEvent(userProfile)),
      expect: [LoadingProfileState(), CompleteProfileState(userProfile)],
    );

    blocTest(
      'should yield Loading and Error on failure',
      build: () async {
        when(mockedAuthBloc.listen(any)).thenReturn(MockedStreamSubscription());
        when(mockedProfileFacade.addUserProfile(
                userProfile: anyNamed('userProfile')))
            .thenAnswer((_) async => Left(DataFailure()));
        return ProfileBloc(
          profileFacade: mockedProfileFacade,
          authBloc: mockedAuthBloc,
        );
      },
      act: (ProfileBloc bloc) async =>
          bloc.add(AddUserProfileEvent(userProfile)),
      expect: [LoadingProfileState(), ErrorProfileState(DataFailure())],
    );
  });

  group('resetProfile', () {
    blocTest(
      'should yield Empty on reset',
      build: () async {
        when(mockedAuthBloc.listen(any)).thenReturn(MockedStreamSubscription());
        return ProfileBloc(
          profileFacade: mockedProfileFacade,
          authBloc: mockedAuthBloc,
        );
      },
      act: (ProfileBloc bloc) async => bloc.add(ResetUserProfileEvent()),
      expect: [EmptyProfileState()],
    );
  });

  group('changePremiumCollectionsAvailable', () {
    test('should return false if cannot create premium collection', () async {
      final ProfileBloc profileBloc = ProfileBloc(
          profileFacade: mockedProfileFacade, authBloc: mockedAuthBloc);

      final bool result =
          await profileBloc.changePremiumCollectionsAvailable(by: 1);

      expect(result, isFalse);

      profileBloc.close();
    });
  });
}
