import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../model/user_profile.dart';
import '../../service/data_service.dart';
import '../../util/error/data_failure.dart';

abstract class ProfileFacade {
  DataService dataService;

  Future<Either<DataFailure, UserProfile>> getUserProfile(
      {@required String username});

  Future<Either<DataFailure, void>> addUserProfile(
      {@required UserProfile userProfile});
}
