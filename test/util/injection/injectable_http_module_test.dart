import 'package:collectio/util/injection/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart' show Environment;

void main() {
  configureInjection(Environment.prod);

  test('should get real http client', () {
    // Do not type result, otherwise the test has no point!
    final result = getIt<http.Client>();

    expect(result.runtimeType.toString(), equals('IOClient'));
  });
}
