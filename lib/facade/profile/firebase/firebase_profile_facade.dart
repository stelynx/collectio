import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import '../../../model/user_profile.dart';
import '../../../service/data_service.dart';
import '../../../util/constant/constants.dart';
import '../../../util/error/data_failure.dart';
import '../profile_facade.dart';

@prod
@lazySingleton
@RegisterAs(ProfileFacade)
class FirebaseProfileFacade extends ProfileFacade {
  final DataService dataService;

  FirebaseProfileFacade({@required this.dataService});

  @override
  Future<Either<DataFailure, void>> addUserProfile({
    @required UserProfile userProfile,
  }) async {
    final String id = userProfile.username;
    final Map<String, dynamic> userProfileJson = userProfile.toJson();

    try {
      await dataService.addUserProfile(id: id, userProfile: userProfileJson);
      return Right(null);
    } catch (e) {
      return Left(DataFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<DataFailure, UserProfile>> getUserProfile({
    @required String username,
  }) async {
    try {
      final QuerySnapshot userProfileQuerySnapshot =
          await dataService.getUserProfile(username: username);

      final List<DocumentSnapshot> documents =
          userProfileQuerySnapshot.documents;
      if (documents.length != 1) {
        return Left(DataFailure(message: Constants.notExactlyOneObjectFound));
      }

      final UserProfile userProfile = UserProfile.fromJson(documents[0].data);
      return Right(userProfile);
    } catch (e) {
      return Left(DataFailure(message: e.toString()));
    }
  }
}

@test
@lazySingleton
@RegisterAs(ProfileFacade)
class MockedFirebaseProfileFacade extends Mock implements ProfileFacade {}
