import 'package:collectio/model/collection_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should get correct JSON from toJson()', () {
    final DateTime added = DateTime.now();
    final CollectionItem collectionItem = CollectionItem(
      id: 'title',
      description: 'description',
      title: 'title',
      subtitle: 'subtitle',
      imageUrl: 'imageUrl',
      raiting: 10,
      added: added,
    );
    final Map<String, dynamic> collectionItemJson = <String, dynamic>{
      'description': 'description',
      'title': 'title',
      'subtitle': 'subtitle',
      'image': 'imageUrl',
      'raiting': 10,
      'added': added.millisecondsSinceEpoch,
    };

    final Map<String, dynamic> result = collectionItem.toJson();

    expect(result, equals(collectionItemJson));
  });

  test('should get correct CollectionItem from CollectionItem.fromJson()', () {
    final DateTime added = DateTime.now();
    final CollectionItem collectionItem = CollectionItem(
      id: 'title',
      description: 'description',
      title: 'title',
      subtitle: 'subtitle',
      imageUrl: 'imageUrl',
      raiting: 10,
      added: added,
    );
    final Map<String, dynamic> collectionItemJson = <String, dynamic>{
      'id': 'title',
      'description': 'description',
      'title': 'title',
      'subtitle': 'subtitle',
      'image': 'imageUrl',
      'raiting': 10,
      'added': added.millisecondsSinceEpoch,
    };

    final CollectionItem result = CollectionItem.fromJson(collectionItemJson);

    expect(result, equals(collectionItem));
  });
}
