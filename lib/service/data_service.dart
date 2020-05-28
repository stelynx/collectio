import 'package:meta/meta.dart';

abstract class DataService {
  Future getCollectionsForUser(String username);

  Future getItemsInCollection(
      {@required String username, @required String collectionName});

  Future getUserProfileByUsername({@required String username});

  Future getUserProfileByUserUid({@required String userUid});

  Future<void> addCollection({
    @required String owner,
    @required String id,
    @required Map<String, dynamic> collection,
  });

  Future<void> addItemToCollection({
    @required String owner,
    @required String collectionName,
    @required Map<String, dynamic> item,
  });

  Future<void> addUserProfile(
      {@required String id, @required Map<String, dynamic> userProfile});

  Future<void> updateUserProfile(
      {@required String id, @required Map<String, dynamic> userProfile});

  Future<void> deleteCollection(
      {@required String owner, @required String collectionName});

  Future<void> deleteItemInCollection({
    @required String owner,
    @required String collectionName,
    @required String itemId,
  });
}
