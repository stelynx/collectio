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

  Future<void> addUserProfile(
      {@required String id, @required Map<String, dynamic> userProfile});
}
