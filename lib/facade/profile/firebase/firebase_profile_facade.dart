import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import '../../../model/user_profile.dart';
import '../../../service/data_service.dart';
import '../../../service/storage_service.dart';
import '../../../util/constant/constants.dart';
import '../../../util/error/data_failure.dart';
import '../profile_facade.dart';

@prod
@lazySingleton
@RegisterAs(ProfileFacade)
class FirebaseProfileFacade extends ProfileFacade {
  final DataService dataService;
  final StorageService storageService;

  FirebaseProfileFacade(
      {@required this.dataService, @required this.storageService});

  @override
  Future<Either<DataFailure, void>> addUserProfile({
    @required UserProfile userProfile,
  }) async {
    final String id = userProfile.id;
    final Map<String, dynamic> userProfileJson = userProfile.toJson();

    try {
      await dataService.addUserProfile(id: id, userProfile: userProfileJson);
      return Right(null);
    } catch (e) {
      return Left(DataFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<DataFailure, UserProfile>> getUserProfileByUsername({
    @required String username,
  }) async {
    try {
      final QuerySnapshot userProfileQuerySnapshot =
          await dataService.getUserProfileByUsername(username: username);

      final List<DocumentSnapshot> documents =
          userProfileQuerySnapshot.documents;
      if (documents.length != 1) {
        return Left(DataFailure(message: Constants.notExactlyOneObjectFound));
      }

      final Map<String, dynamic> profileJson = documents[0].data;
      profileJson['image'] = await storageService.getProfileImageUrl(
          imageName: profileJson['image']);

      final UserProfile userProfile = UserProfile.fromJson(profileJson);
      return Right(userProfile);
    } catch (e) {
      return Left(DataFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<DataFailure, UserProfile>> getUserProfileByUserUid({
    @required String userUid,
  }) async {
    try {
      final QuerySnapshot userProfileQuerySnapshot =
          await dataService.getUserProfileByUserUid(userUid: userUid);

      final List<DocumentSnapshot> documents =
          userProfileQuerySnapshot.documents;
      if (documents.length != 1) {
        return Left(DataFailure(message: Constants.notExactlyOneObjectFound));
      }

      final Map<String, dynamic> profileJson = documents[0].data;
      profileJson['profileImg'] = await storageService.getProfileImageUrl(
          imageName: profileJson['profileImg']);

      final UserProfile userProfile = UserProfile.fromJson(profileJson);
      return Right(userProfile);
    } catch (e) {
      return Left(DataFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<DataFailure, void>> editUserProfile({
    @required UserProfile userProfile,
    @required File profileImage,
  }) async {
    try {
      if (profileImage != null) {
        final String fileExtension =
            profileImage.path.substring(profileImage.path.lastIndexOf('.') + 1);

        final String destinationName = '${userProfile.username}.$fileExtension';

        final bool uploadSuccessful = await storageService.uploadProfileImage(
          image: profileImage,
          destinationName: destinationName,
        );

        if (!uploadSuccessful) return Left(DataFailure());

        userProfile.profileImg = destinationName;
      } else {
        userProfile.profileImg = '';
      }

      await dataService.updateUserProfile(
        id: userProfile.id,
        userProfile: userProfile.toJson(),
      );

      return Right(null);
    } catch (_) {
      return Left(DataFailure());
    }
  }
}

@test
@lazySingleton
@RegisterAs(ProfileFacade)
class MockedFirebaseProfileFacade extends Mock implements ProfileFacade {}
