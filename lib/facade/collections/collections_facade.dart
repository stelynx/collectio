import 'package:dartz/dartz.dart';

import '../../model/collection.dart';
import '../../util/error/data_failure.dart';

abstract class CollectionsFacade {
  Future<Either<DataFailure, List<Collection>>> getCollectionsForUser(
      String username);
}
