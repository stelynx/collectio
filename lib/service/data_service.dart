import 'package:meta/meta.dart';

abstract class DataService {
  Future getCollectionsForUser(String username);

  Future getItemsInCollection(
      {@required String username, @required String collectionName});
}
