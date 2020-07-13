import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

@registerModule
abstract class InjectableHttpModule {
  @prod
  @injectable
  http.Client get client => http.Client();

  @test
  @injectable
  http.Client get mockedClient => MockedHttpClient();
}

class MockedHttpClient extends Mock implements http.Client {}
