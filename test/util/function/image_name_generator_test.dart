import 'package:collectio/util/function/image_name_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('getItemImageName', () {
    test('should return filename with data concatenated with underscores', () {
      final String owner = 'owner';
      final String collectionName = 'collectionName';
      final String itemTitle = 'title';
      final String fileExtension = 'jpg';

      final String result =
          getItemImageName(owner, collectionName, itemTitle, fileExtension);

      expect(result,
          equals('${owner}_${collectionName}_$itemTitle.$fileExtension'));
    });
  });

  group('getCollectionThumbnailName', () {
    test('should return filename with data concatenated with underscores', () {
      final String owner = 'owner';
      final String collectionName = 'collectionName';
      final String fileExtension = 'jpg';

      final String result =
          getCollectionThumbnailName(owner, collectionName, fileExtension);

      expect(result, equals('${owner}_$collectionName.$fileExtension'));
    });
  });
}
