import 'package:collectio/model/collection.dart';
import 'package:collectio/model/interface/listable.dart';
import 'package:collectio/util/function/listable_finder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('findById', () {
    final Listable listable = Collection(
      id: 'id123',
      owner: null,
      title: null,
      subtitle: null,
      description: null,
      thumbnail: null,
    );
    final List<Listable> listables = [listable];

    test('should return null if no item has been found', () {
      final String id = 'id1234';

      final Listable result = ListableFinder.findById(listables, id);

      expect(result, isNull);
    });

    test('should return correct entry if found', () {
      final String id = 'id123';

      final Listable result = ListableFinder.findById(listables, id);

      expect(result, equals(listable));
    });
  });
}
