import 'package:collectio/model/collection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should get correct JSON from toJson()', () {
    final Collection collection = Collection(
      id: 'title',
      owner: 'owner',
      description: 'description',
      title: 'title',
      subtitle: 'subtitle',
      thumbnail: 'thumbnail',
    );
    final Map<String, dynamic> collectionJson = <String, dynamic>{
      'owner': 'owner',
      'description': 'description',
      'title': 'title',
      'subtitle': 'subtitle',
      'thumbnail': 'thumbnail',
    };

    final Map<String, dynamic> result = collection.toJson();

    expect(result, equals(collectionJson));
  });

  test('should get correct Collection from Collection.fromJson()', () {
    final Collection collection = Collection(
      id: 'title',
      owner: 'owner',
      description: 'description',
      title: 'title',
      subtitle: 'subtitle',
      thumbnail: 'thumbnail',
    );
    final Map<String, dynamic> collectionJson = <String, dynamic>{
      'owner': 'owner',
      'description': 'description',
      'title': 'title',
      'subtitle': 'subtitle',
      'thumbnail': 'thumbnail',
    };

    final Collection result = Collection.fromJson(collectionJson);

    expect(result, equals(collection));
  });
}
