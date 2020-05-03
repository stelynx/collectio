import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../model/collection.dart';
import '../../model/collection_item.dart';
import '../../util/error/data_failure.dart';

abstract class CollectionsFacade {
  Future<Either<DataFailure, List<Collection>>> getCollectionsForUser(
      String username);

  Future<Either<DataFailure, void>> addCollection(Collection collection);

  Future<Either<DataFailure, List<CollectionItem>>> getItemsInCollection(
      String owner, String collectionId);

  Future<Either<DataFailure, void>> addItemToCollection({
    @required String owner,
    @required String collectionName,
    @required CollectionItem item,
  });
}
