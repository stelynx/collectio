import 'package:flutter/material.dart';

import '../screen/auth/sign_in.dart';
import '../screen/initial.dart';
import '../screen/shared/error.dart';

class Router {
  static const String initial = '/';
  static const String signIn = '/sign-in';
  static const String error = '/error';

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    final Object routeArguments = routeSettings.arguments;

    switch (routeSettings.name) {
      case Router.initial:
        return MaterialPageRoute(builder: (_) => InitialScreen());
      case Router.signIn:
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case Router.error:
        return MaterialPageRoute(
            builder: (_) => ErrorScreen(message: routeArguments));
      default:
        return MaterialPageRoute(
            builder: (_) => ErrorScreen(message: 'Unknown route'));
    }
  }

  static void navigate(RouteSettings routeSettings) {}
}
