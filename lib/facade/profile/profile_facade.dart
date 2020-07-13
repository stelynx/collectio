import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../model/user_profile.dart';
import '../../service/data_service.dart';
import '../../util/error/data_failure.dart';

abstract class ProfileFacade {
  DataService dataService;

  /// Gets user profile by [username].
  Future<Either<DataFailure, UserProfile>> getUserProfileByUsername(
      {@required String username});

  /// Gets user profile by [userUid].
  Future<Either<DataFailure, UserProfile>> getUserProfileByUserUid(
      {@required String userUid});

  /// Adds [userProfile] to database.
  Future<Either<DataFailure, void>> addUserProfile(
      {@required UserProfile userProfile});

  /// Updates [userProfile] and adds [profileImage].
  Future<Either<DataFailure, void>> editUserProfile(
      {@required UserProfile userProfile, @required File profileImage});
}
