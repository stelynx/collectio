import 'package:collectio/app/routes/router.dart';
import 'package:collectio/app/routes/routes.dart';
import 'package:collectio/app/screen/auth/sign_in.dart';
import 'package:collectio/app/screen/collections/all/collections.dart';
import 'package:collectio/app/screen/initial.dart';
import 'package:collectio/app/screen/shared/error.dart';
import 'package:collectio/util/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('onGenerateRoute', () {
    test('should map Routes.initial to InitialScreen', () {
      final String path = Routes.initial;
      final RouteSettings routeSettings = RouteSettings(name: path);

      final MaterialPageRoute result = Router.onGenerateRoute(routeSettings);

      expect(result.builder(null), isA<InitialScreen>());
    });

    test('should map Routes.signIn to SignInScreen', () {
      final String path = Routes.signIn;
      final RouteSettings routeSettings = RouteSettings(name: path);

      final MaterialPageRoute result = Router.onGenerateRoute(routeSettings);

      expect(result.builder(null), isA<SignInScreen>());
    });

    test('should map Routes.myCollections to CollectionsScreen', () {
      final String path = Routes.myCollections;
      final RouteSettings routeSettings = RouteSettings(name: path);

      final MaterialPageRoute result = Router.onGenerateRoute(routeSettings);

      expect(result.builder(null), isA<CollectionsScreen>());
    });

    test('should map Routes.error to ErrorScreen with appropriate message', () {
      final String path = Routes.error;
      final String errorMessage = 'Error message';
      final RouteSettings routeSettings =
          RouteSettings(name: path, arguments: errorMessage);

      final MaterialPageRoute result = Router.onGenerateRoute(routeSettings);
      final Widget screen = result.builder(null);

      expect(screen, isA<ErrorScreen>());

      ErrorScreen errorScreen = screen as ErrorScreen;
      expect(errorScreen.errorMessage, equals(errorMessage));
    });

    test('should map unknown route to ErrorScreen', () {
      final String path = '/someUnknownRoute';
      final RouteSettings routeSettings = RouteSettings(name: path);

      final MaterialPageRoute result = Router.onGenerateRoute(routeSettings);
      final Widget screen = result.builder(null);

      expect(screen, isA<ErrorScreen>());

      ErrorScreen errorScreen = screen as ErrorScreen;
      expect(errorScreen.errorMessage, equals(Constants.unknownRouteMessage));
    });
  });
}
