String getItemImageName(
  String owner,
  String collectionName,
  String uniqueIdentificator,
  String fileExtension,
) =>
    '${owner}_${collectionName}_$uniqueIdentificator.$fileExtension';

String getCollectionThumbnailName(
  String owner,
  String collectionName,
  String fileExtension,
) =>
    '${owner}_$collectionName.$fileExtension';
