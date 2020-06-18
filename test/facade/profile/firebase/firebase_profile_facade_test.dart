import 'package:collectio/facade/profile/firebase/firebase_profile_facade.dart';
import 'package:collectio/model/user_profile.dart';
import 'package:collectio/service/data_service.dart';
import 'package:collectio/service/storage_service.dart';
import 'package:collectio/util/constant/translation.dart';
import 'package:collectio/util/error/data_failure.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;
import 'package:mockito/mockito.dart';

import '../../../mocks.dart';

void main() {
  configureInjection(Environment.test);

  UserProfile userProfile;
  Map<String, dynamic> userProfileJson;

  FirebaseProfileFacade firebaseProfileFacade;

  setUp(() {
    firebaseProfileFacade = FirebaseProfileFacade(
      dataService: getIt<DataService>(),
      storageService: getIt<StorageService>(),
    );
    userProfile = UserProfile(
      email: 'email',
      userUid: 'userUid',
      username: 'username',
      profileImg: 'profileImage',
    );
    userProfileJson = userProfile.toJson();
  });

  group('addUserProfile', () {
    test('should call data service with correct arguments', () async {
      when(firebaseProfileFacade.dataService.addUserProfile(
        id: anyNamed('id'),
        userProfile: anyNamed('userProfile'),
      )).thenAnswer((_) async => null);

      await firebaseProfileFacade.addUserProfile(userProfile: userProfile);

      verify(firebaseProfileFacade.dataService.addUserProfile(
        id: userProfile.username,
        userProfile: userProfileJson,
      )).called(1);
    });

    test('should return Right(null) on success', () async {
      when(firebaseProfileFacade.dataService.addUserProfile(
        id: anyNamed('id'),
        userProfile: anyNamed('userProfile'),
      )).thenAnswer((_) async => null);

      final Either<DataFailure, void> result =
          await firebaseProfileFacade.addUserProfile(userProfile: userProfile);

      expect(result, equals(Right(null)));
    });

    test('should return Left(DataFailure) on success', () async {
      when(firebaseProfileFacade.dataService.addUserProfile(
        id: anyNamed('id'),
        userProfile: anyNamed('userProfile'),
      )).thenThrow(Exception());

      final Either<DataFailure, void> result =
          await firebaseProfileFacade.addUserProfile(userProfile: userProfile);

      expect(result, equals(Left(DataFailure())));
    });
  });

  group('getUserProfileByUsername', () {
    final String username = 'username';

    test('should call data service with correct arguments', () async {
      when(firebaseProfileFacade.dataService
              .getUserProfileByUsername(username: anyNamed('username')))
          .thenAnswer((_) async => null);

      await firebaseProfileFacade.getUserProfileByUsername(username: username);

      verify(firebaseProfileFacade.dataService
              .getUserProfileByUsername(username: username))
          .called(1);
    });

    test('should return Right(UserProfile) on success', () async {
      when(firebaseProfileFacade.dataService
              .getUserProfileByUsername(username: anyNamed('username')))
          .thenAnswer((_) async => MockedQuerySnapshot(
              [MockedDocumentSnapshot(username, userProfileJson)]));

      final Either<DataFailure, UserProfile> result =
          await firebaseProfileFacade.getUserProfileByUsername(
              username: username);

      expect(result, equals(Right(userProfile)));
    });

    test(
        'should return Left(DataFailure) with appropriate message when 0 matches',
        () async {
      when(firebaseProfileFacade.dataService
              .getUserProfileByUsername(username: anyNamed('username')))
          .thenAnswer((_) async => MockedQuerySnapshot([]));

      final Either<DataFailure, UserProfile> result =
          await firebaseProfileFacade.getUserProfileByUsername(
              username: username);

      expect(
        result,
        equals(
            Left(DataFailure(message: Translation.notExactlyOneObjectFound))),
      );
    });

    test(
        'should return Left(DataFailure) with appropriate message when 2+ matches',
        () async {
      when(firebaseProfileFacade.dataService
              .getUserProfileByUsername(username: anyNamed('username')))
          .thenAnswer(
        (_) async => MockedQuerySnapshot([
          MockedDocumentSnapshot(username, userProfileJson),
          MockedDocumentSnapshot(username, userProfileJson),
        ]),
      );

      final Either<DataFailure, UserProfile> result =
          await firebaseProfileFacade.getUserProfileByUsername(
              username: username);

      expect(
        result,
        equals(
            Left(DataFailure(message: Translation.notExactlyOneObjectFound))),
      );
    });

    test('should return Left(DataFailure) on exception', () async {
      when(firebaseProfileFacade.dataService
              .getUserProfileByUsername(username: anyNamed('username')))
          .thenThrow(Exception());

      final Either<DataFailure, UserProfile> result =
          await firebaseProfileFacade.getUserProfileByUsername(
              username: username);

      expect(
        result,
        equals(Left(DataFailure())),
      );
    });

    test('should get user\'s profile image url', () async {
      when(firebaseProfileFacade.dataService
              .getUserProfileByUsername(username: anyNamed('username')))
          .thenAnswer((_) async => MockedQuerySnapshot(
              [MockedDocumentSnapshot(username, userProfileJson)]));
      when(firebaseProfileFacade.storageService
              .getProfileImageUrl(imageName: anyNamed('imageName')))
          .thenAnswer((_) async => null);

      await firebaseProfileFacade.getUserProfileByUsername(username: username);

      verify(firebaseProfileFacade.storageService
          .getProfileImageUrl(imageName: userProfile.profileImg));
    });

    test(
      'should set user\'s profile image url to null if exception occured while getting url',
      () async {
        when(firebaseProfileFacade.dataService
                .getUserProfileByUsername(username: anyNamed('username')))
            .thenAnswer((_) async => MockedQuerySnapshot(
                [MockedDocumentSnapshot(username, userProfileJson)]));
        when(firebaseProfileFacade.storageService
                .getProfileImageUrl(imageName: anyNamed('imageName')))
            .thenThrow(Exception());

        final Either<DataFailure, UserProfile> result =
            await firebaseProfileFacade.getUserProfileByUsername(
                username: username);

        expect(result.isRight(), isTrue);

        final UserProfile userProfile = result.getOrElse(() => null);
        expect(userProfile.profileImg, isNull);
      },
    );
  });

  group('getUserProfileByUserUid', () {
    final String userUid = 'userUid';

    test('should call data service with correct arguments', () async {
      when(firebaseProfileFacade.dataService
              .getUserProfileByUserUid(userUid: anyNamed('userUid')))
          .thenAnswer((_) async => null);

      await firebaseProfileFacade.getUserProfileByUserUid(userUid: userUid);

      verify(firebaseProfileFacade.dataService
              .getUserProfileByUserUid(userUid: userUid))
          .called(1);
    });

    test('should return Right(UserProfile) on success', () async {
      when(firebaseProfileFacade.dataService
              .getUserProfileByUserUid(userUid: anyNamed('userUid')))
          .thenAnswer((_) async => MockedQuerySnapshot(
              [MockedDocumentSnapshot(userUid, userProfileJson)]));

      final Either<DataFailure, UserProfile> result =
          await firebaseProfileFacade.getUserProfileByUserUid(userUid: userUid);

      expect(result, equals(Right(userProfile)));
    });

    test(
        'should return Left(DataFailure) with appropriate message when 0 matches',
        () async {
      when(firebaseProfileFacade.dataService
              .getUserProfileByUserUid(userUid: anyNamed('userUid')))
          .thenAnswer((_) async => MockedQuerySnapshot([]));

      final Either<DataFailure, UserProfile> result =
          await firebaseProfileFacade.getUserProfileByUserUid(userUid: userUid);

      expect(
        result,
        equals(
            Left(DataFailure(message: Translation.notExactlyOneObjectFound))),
      );
    });

    test(
        'should return Left(DataFailure) with appropriate message when 2+ matches',
        () async {
      when(firebaseProfileFacade.dataService
              .getUserProfileByUserUid(userUid: anyNamed('userUid')))
          .thenAnswer(
        (_) async => MockedQuerySnapshot([
          MockedDocumentSnapshot(userUid, userProfileJson),
          MockedDocumentSnapshot(userUid, userProfileJson),
        ]),
      );

      final Either<DataFailure, UserProfile> result =
          await firebaseProfileFacade.getUserProfileByUserUid(userUid: userUid);

      expect(
        result,
        equals(
            Left(DataFailure(message: Translation.notExactlyOneObjectFound))),
      );
    });

    test('should return Left(DataFailure) on exception', () async {
      when(firebaseProfileFacade.dataService
              .getUserProfileByUserUid(userUid: anyNamed('userUid')))
          .thenThrow(Exception());

      final Either<DataFailure, UserProfile> result =
          await firebaseProfileFacade.getUserProfileByUserUid(userUid: userUid);

      expect(
        result,
        equals(Left(DataFailure())),
      );
    });

    test('should get user\'s profile image url', () async {
      when(firebaseProfileFacade.dataService
              .getUserProfileByUserUid(userUid: anyNamed('userUid')))
          .thenAnswer((_) async => MockedQuerySnapshot(
              [MockedDocumentSnapshot(userUid, userProfileJson)]));
      when(firebaseProfileFacade.storageService
              .getProfileImageUrl(imageName: anyNamed('imageName')))
          .thenAnswer((_) async => null);

      await firebaseProfileFacade.getUserProfileByUserUid(userUid: userUid);

      verify(firebaseProfileFacade.storageService
          .getProfileImageUrl(imageName: userProfile.profileImg));
    });

    test(
      'should set user\'s profile image url to null if exception occured while getting url',
      () async {
        when(firebaseProfileFacade.dataService
                .getUserProfileByUserUid(userUid: anyNamed('userUid')))
            .thenAnswer((_) async => MockedQuerySnapshot(
                [MockedDocumentSnapshot(userUid, userProfileJson)]));
        when(firebaseProfileFacade.storageService
                .getProfileImageUrl(imageName: anyNamed('imageName')))
            .thenThrow(Exception());

        final Either<DataFailure, UserProfile> result =
            await firebaseProfileFacade.getUserProfileByUserUid(
                userUid: userUid);

        expect(result.isRight(), isTrue);

        final UserProfile userProfile = result.getOrElse(() => null);
        expect(userProfile.profileImg, isNull);
      },
    );
  });

  group('editUserProfile', () {
    final MockedFile image = MockedFile();

    test('should call StorageService.uploadProfileImage when given image',
        () async {
      when(firebaseProfileFacade.storageService.uploadProfileImage(
              image: anyNamed('image'),
              destinationName: anyNamed('destinationName')))
          .thenAnswer((_) async => true);
      when(image.path).thenReturn('image.jpg');

      await firebaseProfileFacade.editUserProfile(
          userProfile: userProfile, profileImage: image);

      verify(firebaseProfileFacade.storageService.uploadProfileImage(
              image: image, destinationName: '${userProfile.username}.jpg'))
          .called(1);
    });

    test('should not call StorageService.uploadProfileImage when no image',
        () async {
      await firebaseProfileFacade.editUserProfile(
          userProfile: userProfile, profileImage: null);

      verifyNever(firebaseProfileFacade.storageService.uploadProfileImage(
          image: anyNamed('image'),
          destinationName: anyNamed('destinationName')));
    });

    test(
      'should call DataService.updateUserProfile with given profile and image',
      () async {
        final UserProfile newUserProfile = userProfile;
        newUserProfile.username = 'username2';

        when(firebaseProfileFacade.storageService.uploadProfileImage(
                image: anyNamed('image'),
                destinationName: anyNamed('destinationName')))
            .thenAnswer((_) async => true);
        when(image.path).thenReturn('${newUserProfile.id}.jpg');
        when(firebaseProfileFacade.dataService.updateUserProfile(
                id: anyNamed('id'), userProfile: anyNamed('userProfile')))
            .thenAnswer((_) async => null);

        await firebaseProfileFacade.editUserProfile(
            userProfile: newUserProfile, profileImage: image);

        newUserProfile.profileImg = '${newUserProfile.id}.jpg';

        verify(firebaseProfileFacade.dataService.updateUserProfile(
                id: newUserProfile.id, userProfile: newUserProfile.toJson()))
            .called(1);
      },
    );

    test('should return Right(null) when everything is successful', () async {
      final UserProfile newUserProfile = userProfile;
      newUserProfile.username = 'username3';

      when(firebaseProfileFacade.storageService.uploadProfileImage(
              image: anyNamed('image'),
              destinationName: anyNamed('destinationName')))
          .thenAnswer((_) async => true);
      when(image.path).thenReturn('${newUserProfile.id}.jpg');
      when(firebaseProfileFacade.dataService.updateUserProfile(
              id: anyNamed('id'), userProfile: anyNamed('userProfile')))
          .thenAnswer((_) async => null);

      final Either<DataFailure, void> result = await firebaseProfileFacade
          .editUserProfile(userProfile: newUserProfile, profileImage: image);

      expect(result, equals(Right(null)));
    });

    test(
      'should return Left(DataFailure) when image upload throws exception',
      () async {
        final UserProfile newUserProfile = userProfile;
        newUserProfile.username = 'username3';

        when(firebaseProfileFacade.storageService.uploadProfileImage(
                image: anyNamed('image'),
                destinationName: anyNamed('destinationName')))
            .thenThrow(Exception());
        when(image.path).thenReturn('${newUserProfile.id}.jpg');

        final Either<DataFailure, void> result = await firebaseProfileFacade
            .editUserProfile(userProfile: newUserProfile, profileImage: image);

        expect(result, equals(Left(DataFailure())));
      },
    );

    test(
      'should return Left(DataFailure) when image upload fails',
      () async {
        final UserProfile newUserProfile = userProfile;
        newUserProfile.username = 'username3';

        when(firebaseProfileFacade.storageService.uploadProfileImage(
                image: anyNamed('image'),
                destinationName: anyNamed('destinationName')))
            .thenAnswer((_) async => false);
        when(image.path).thenReturn('${newUserProfile.id}.jpg');

        final Either<DataFailure, void> result = await firebaseProfileFacade
            .editUserProfile(userProfile: newUserProfile, profileImage: image);

        expect(result, equals(Left(DataFailure())));
      },
    );

    test(
      'should return Left(DataFailure) when updating profile fails',
      () async {
        final UserProfile newUserProfile = userProfile;
        newUserProfile.username = 'username4';

        when(firebaseProfileFacade.storageService.uploadProfileImage(
                image: anyNamed('image'),
                destinationName: anyNamed('destinationName')))
            .thenAnswer((_) async => true);
        when(image.path).thenReturn('${newUserProfile.id}.jpg');
        when(firebaseProfileFacade.dataService.updateUserProfile(
                id: anyNamed('id'), userProfile: anyNamed('userProfile')))
            .thenThrow(Exception());

        final Either<DataFailure, void> result = await firebaseProfileFacade
            .editUserProfile(userProfile: newUserProfile, profileImage: image);

        expect(result, equals(Left(DataFailure())));
      },
    );
  });
}
