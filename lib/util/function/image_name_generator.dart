import 'package:collectio/util/function/id_generator.dart';

String getItemImageName(
  String owner,
  String collectionName,
  String itemTitle,
  String fileExtension,
) =>
    '${owner}_${collectionName}_${getId(itemTitle)}.$fileExtension';

String getCollectionThumbnailName(
  String owner,
  String collectionName,
  String fileExtension,
) =>
    '${owner}_$collectionName.$fileExtension';
