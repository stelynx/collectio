import 'package:collectio/service/data_service.dart';
import 'package:dartz/dartz.dart';

import '../../model/user_profile.dart';
import '../../util/error/data_failure.dart';

abstract class ProfileFacade {
  DataService dataService;

  Future<Either<DataFailure, UserProfile>> getUserProfile();

  Future<Either<DataFailure, void>> addUserProfile();
}
