import 'package:collectio/util/function/id_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should return empty string on null', () {
    final String from = null;

    final String result = getId(from);

    expect(result, isNull);
  });

  test('should return lowercased string with underscores instead of spaces',
      () {
    final String from = 'daSWc sd2 aHw';
    final String to = 'daswc_sd2_ahw';

    final String result = getId(from);

    expect(result, equals(to));
  });
}
