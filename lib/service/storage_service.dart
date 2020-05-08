import 'dart:io';

import 'package:meta/meta.dart';

abstract class StorageService {
  void uploadCollectionThumbnail(
      {@required File image, @required String destinationName});

  void uploadItemImage(
      {@required File image, @required String destinationName});

  Future<String> getCollectionThumbnailUrl({@required String imageName});

  Future<String> getItemImageUrl({@required String imageName});
}
