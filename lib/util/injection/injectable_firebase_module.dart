import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

@registerModule
abstract class InjectableFirebaseModule {
  @prod
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @test
  @lazySingleton
  FirebaseAuth get mockedFirebaseAuth => MockedFirebaseAuth();
}

class MockedFirebaseAuth extends Mock implements FirebaseAuth {}
