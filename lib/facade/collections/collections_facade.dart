import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../model/collection.dart';
import '../../model/collection_item.dart';
import '../../util/error/data_failure.dart';

abstract class CollectionsFacade {
  Future<Either<DataFailure, List<Collection>>> getCollectionsForUser(
      String username);

  Future<Either<DataFailure, void>> addCollection(Collection collection);

  Future<Either<DataFailure, void>> deleteCollection(Collection collection);

  Future<Either<DataFailure, List<CollectionItem>>> getItemsInCollection(
      Collection parent);

  Future<Either<DataFailure, void>> addItemToCollection({
    @required String owner,
    @required String collectionName,
    @required CollectionItem item,
  });

  Future<Either<DataFailure, void>> deleteItemInCollection({
    @required CollectionItem collectionItem,
  });

  Future<Either<DataFailure, void>> uploadCollectionThumbnail({
    @required File image,
    @required String destinationName,
  });

  Future<Either<DataFailure, void>> uploadCollectionItemImage({
    @required File image,
    @required String destinationName,
  });
}
