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

  test('should implement Listable get thumbnail', () {
    final CollectionItem collectionItem = CollectionItem(
      id: 'title',
      description: 'description',
      title: 'title',
      subtitle: 'subtitle',
      imageUrl: 'imageUrl',
      raiting: 10,
      added: null,
    );

    final String thumbnail = collectionItem.thumbnail;

    expect(thumbnail, equals(collectionItem.imageUrl));
  });

  test('should have order by added via compare()', () {
    final int now = DateTime.now().millisecondsSinceEpoch;
    final CollectionItem collectionItem1 = CollectionItem(
      added: DateTime.fromMillisecondsSinceEpoch(now - 1000),
      title: null,
      subtitle: null,
      description: null,
      imageUrl: null,
      raiting: null,
    );
    final CollectionItem collectionItem2 = CollectionItem(
      added: DateTime.fromMillisecondsSinceEpoch(now - 900),
      title: null,
      subtitle: null,
      description: null,
      imageUrl: null,
      raiting: null,
    );
    final CollectionItem collectionItem3 = CollectionItem(
      added: DateTime.fromMillisecondsSinceEpoch(now - 500),
      title: null,
      subtitle: null,
      description: null,
      imageUrl: null,
      raiting: null,
    );
    final CollectionItem collectionItem4 = CollectionItem(
      added: DateTime.fromMillisecondsSinceEpoch(now),
      title: null,
      subtitle: null,
      description: null,
      imageUrl: null,
      raiting: null,
    );

    final List<CollectionItem> unsortedItems = <CollectionItem>[
      collectionItem3,
      collectionItem2,
      collectionItem4,
      collectionItem1,
    ];
    final List<CollectionItem> sortedItems = <CollectionItem>[
      collectionItem1,
      collectionItem2,
      collectionItem3,
      collectionItem4,
    ];

    final List<CollectionItem> result = unsortedItems
      ..sort(CollectionItem.compare);

    expect(result, equals(sortedItems));
  });
}
