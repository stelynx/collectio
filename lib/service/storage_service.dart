import 'dart:io';

import 'package:meta/meta.dart';

abstract class StorageService {
  /// Upload [image] as collection thumbnail and name
  /// [destinationName] to storage.
  Future<bool> uploadCollectionThumbnail(
      {@required File image, @required String destinationName});

  /// Upload [image] as item image and name [destinationName] to storage.
  Future<bool> uploadItemImage(
      {@required File image, @required String destinationName});

  /// Upload [image] as profile image and name [destinationName] to storage.
  Future<bool> uploadProfileImage(
      {@required File image, @required String destinationName});

  /// Get download url for [imageName] that is collection thumbnail.
  Future<String> getCollectionThumbnailUrl({@required String imageName});

  /// Get download url for [imageName] that is item image.
  Future<String> getItemImageUrl({@required String imageName});

  /// Get download url for [imageName] that is profile image.
  Future<String> getProfileImageUrl({@required String imageName});
}
