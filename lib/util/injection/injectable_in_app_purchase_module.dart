import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

@registerModule
abstract class InjectableInAppPurchaseModule {
  @prod
  @injectable
  InAppPurchaseConnection get instance => Platform.isAndroid || Platform.isIOS
      ? InAppPurchaseConnection.instance
      : MockedInAppPurchaseConnection();

  @test
  @injectable
  InAppPurchaseConnection get mockedClient => MockedInAppPurchaseConnection();
}

class MockedInAppPurchaseConnection extends Mock
    implements InAppPurchaseConnection {
  @override
  Future<bool> isAvailable() async => false;
}
