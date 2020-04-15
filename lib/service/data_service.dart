import 'package:meta/meta.dart';

abstract class DataService {
  Future getCollectionsForUser(String username);

  Future getItemsInCollection(
      {@required String username, @required String collectionName});

  Future getUserProfile({@required String userUid});

  Future<void> addUserProfile(
      {@required String id, @required Map<String, dynamic> userProfile});
}
