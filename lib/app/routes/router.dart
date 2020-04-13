import 'package:flutter/material.dart';

import '../../util/constant/constants.dart';
import '../screen/auth/sign_in.dart';
import '../screen/initial.dart';
import '../screen/shared/error.dart';
import 'routes.dart';

abstract class Router {
  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    final Object routeArguments = routeSettings.arguments;

    switch (routeSettings.name) {
      case Routes.initial:
        return MaterialPageRoute(builder: (_) => InitialScreen());
      case Routes.signIn:
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case Routes.error:
        return MaterialPageRoute(
            builder: (_) => ErrorScreen(message: routeArguments));
      default:
        return MaterialPageRoute(
            builder: (_) =>
                ErrorScreen(message: Constants.unknownRouteMessage));
    }
  }
}
