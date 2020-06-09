/// Generates name of item image used for
/// saving to remote storage.
String getItemImageName(
  String owner,
  String collectionName,
  String uniqueIdentificator,
  String fileExtension,
) =>
    '${owner}_${collectionName}_$uniqueIdentificator.$fileExtension';

/// Generates collection thumbnail name used
/// for saving to remote storage.
String getCollectionThumbnailName(
  String owner,
  String collectionName,
  String fileExtension,
) =>
    '${owner}_$collectionName.$fileExtension';
