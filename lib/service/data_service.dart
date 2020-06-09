import 'package:meta/meta.dart';

abstract class DataService {
  /// Returns the collections for user with [username].
  Future getCollectionsForUser(String username);

  /// Returns items in collection which name matches
  /// [collectionName] and belongs to [username].
  Future getItemsInCollection(
      {@required String username, @required String collectionName});

  /// Returns user profile corresponding to user with
  /// username equal to [username].
  Future getUserProfileByUsername({@required String username});

  /// Returns user profile corresponding to user with
  /// id equal to [id].
  Future getUserProfileByUserUid({@required String userUid});

  /// Adds [owner]'s collection with [id] and data [collection]
  /// to collections table.
  Future<void> addCollection({
    @required String owner,
    @required String id,
    @required Map<String, dynamic> collection,
  });

  /// Adds [owner]'s [item] to collection with name [collectionName].
  Future<void> addItemToCollection({
    @required String owner,
    @required String collectionName,
    @required Map<String, dynamic> item,
  });

  /// Adds [userProfile] to item set with [id].
  Future<void> addUserProfile(
      {@required String id, @required Map<String, dynamic> userProfile});

  /// Updates [userProfile] to item set with [id].
  Future<void> updateUserProfile(
      {@required String id, @required Map<String, dynamic> userProfile});

  /// Deletes [owner]'s collection with [collectionName].
  Future<void> deleteCollection(
      {@required String owner, @required String collectionName});

  /// Deletes item in [owner]'s collection with [collectionName].
  Future<void> deleteItemInCollection({
    @required String owner,
    @required String collectionName,
    @required String itemId,
  });
}
