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
      'itemTitleName': 'Title',
      'itemSubtitleName': 'Subtitle',
      'itemDescriptionName': 'Description',
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
      itemTitleName: 'Title123',
      itemSubtitleName: 'Subtitle123',
      itemDescriptionName: 'Description123',
    );
    final Map<String, dynamic> collectionJson = <String, dynamic>{
      'owner': 'owner',
      'description': 'description',
      'title': 'title',
      'subtitle': 'subtitle',
      'thumbnail': 'thumbnail',
      'itemTitleName': 'Title123',
      'itemSubtitleName': 'Subtitle123',
      'itemDescriptionName': 'Description123',
    };

    final Collection result = Collection.fromJson(collectionJson);

    expect(result, equals(collection));
  });

  test('should have alphabetic order by title via compare()', () {
    final Collection collection1 = Collection(
      id: 'aitle',
      owner: 'owner',
      title: 'aitle',
      subtitle: 'subtitle',
      description: 'description',
      thumbnail: 'thumbnail',
    );
    final Collection collection2 = Collection(
      id: 'bitle',
      owner: 'owner',
      title: 'bitle',
      subtitle: 'subtitle',
      description: 'description',
      thumbnail: 'thumbnail',
    );
    final Collection collection3 = Collection(
      id: 'fitle',
      owner: 'owner',
      title: 'fitle',
      subtitle: 'subtitle',
      description: 'description',
      thumbnail: 'thumbnail',
    );
    final Collection collection4 = Collection(
      id: 'title',
      owner: 'owner',
      title: 'title',
      subtitle: 'subtitle',
      description: 'description',
      thumbnail: 'thumbnail',
    );

    final List<Collection> unsortedCollections = <Collection>[
      collection4,
      collection2,
      collection3,
      collection1,
    ];
    final List<Collection> sortedCollections = <Collection>[
      collection1,
      collection2,
      collection3,
      collection4,
    ];

    final List<Collection> result = unsortedCollections
      ..sort(Collection.compare);

    expect(result, equals(sortedCollections));
  });
}
