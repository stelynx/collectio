import 'package:flutter/material.dart';

import '../../model/collection.dart';
import '../../util/constant/constants.dart';
import '../screen/auth/sign_in.dart';
import '../screen/collections/all/collections.dart';
import '../screen/collections/item_details/item_details.dart';
import '../screen/collections/new/new_collection_screen.dart';
import '../screen/collections/new_item/new_item.dart';
import '../screen/collections/one/collection.dart';
import '../screen/initial.dart';
import '../screen/profile/edit_profile/edit_profile_screen.dart';
import '../screen/profile/view_profile/view_profile_screen.dart';
import '../screen/shared/error.dart';
import 'routes.dart';

abstract class Router {
  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    final Object routeArguments = routeSettings.arguments;

    switch (routeSettings.name) {
      case Routes.initial:
        return MaterialPageRoute(builder: (_) => InitialScreen());
      case Routes.signIn:
        return MaterialPageRoute(
          builder: (_) => SignInScreen(),
          maintainState: false,
        );
      case Routes.myCollections:
        return MaterialPageRoute(builder: (_) => CollectionsScreen());
      case Routes.newCollection:
        return MaterialPageRoute(
          builder: (_) => NewCollectionScreen(),
          fullscreenDialog: true,
        );
      case Routes.collection:
        return MaterialPageRoute(
            builder: (_) => CollectionScreen(routeArguments));
      case Routes.item:
        return MaterialPageRoute(
          builder: (_) => ItemDetailsScreen(routeArguments),
          fullscreenDialog: true,
        );
      case Routes.newItem:
        return MaterialPageRoute(
          builder: (_) =>
              NewItemScreen(collection: routeArguments as Collection),
          fullscreenDialog: true,
        );
      case Routes.profile:
        return MaterialPageRoute(
          builder: (_) => ViewProfileScreen(routeArguments),
          fullscreenDialog: true,
        );
      case Routes.editProfile:
        return MaterialPageRoute(
          builder: (_) => EditProfileScreen(),
          fullscreenDialog: true,
        );
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
