import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../model/collection.dart';
import '../../model/collection_item.dart';
import '../../util/error/data_failure.dart';

abstract class CollectionsFacade {
  /// Gets collections for user with username [username].
  Future<Either<DataFailure, List<Collection>>> getCollectionsForUser(
      String username);

  /// Adds [collection] to database.
  Future<Either<DataFailure, void>> addCollection(Collection collection);

  /// Deletes [collection] from database.
  Future<Either<DataFailure, void>> deleteCollection(Collection collection);

  /// Gets items in collection [parent].
  Future<Either<DataFailure, List<CollectionItem>>> getItemsInCollection(
      Collection parent);

  /// Adds [item] to collection with [owner] and id [collectionName].
  Future<Either<DataFailure, void>> addItemToCollection({
    @required String owner,
    @required String collectionName,
    @required CollectionItem item,
  });

  /// Deletes [collectionItem] from its [collectionItem.parent] collection.
  Future<Either<DataFailure, void>> deleteItemInCollection({
    @required CollectionItem collectionItem,
  });

  /// Uploads collection thumbnail [image] to storage as [destinationName].
  Future<Either<DataFailure, void>> uploadCollectionThumbnail({
    @required File image,
    @required String destinationName,
  });

  /// Upload item image [image] to storage as [destinationName].
  Future<Either<DataFailure, void>> uploadCollectionItemImage({
    @required File image,
    @required String destinationName,
  });
}
