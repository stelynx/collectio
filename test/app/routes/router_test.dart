import 'package:collectio/app/routes/router.dart';
import 'package:collectio/app/routes/routes.dart';
import 'package:collectio/app/screen/auth/sign_in.dart';
import 'package:collectio/app/screen/collections/all/collections.dart';
import 'package:collectio/app/screen/collections/item_details/item_details.dart';
import 'package:collectio/app/screen/collections/new/new_collection_screen.dart';
import 'package:collectio/app/screen/collections/new_item/new_item.dart';
import 'package:collectio/app/screen/collections/one/collection.dart';
import 'package:collectio/app/screen/initial.dart';
import 'package:collectio/app/screen/profile/edit_profile/edit_profile_screen.dart';
import 'package:collectio/app/screen/profile/view_profile/view_profile_screen.dart';
import 'package:collectio/app/screen/settings/edit_settings_screen.dart';
import 'package:collectio/app/screen/shared/error.dart';
import 'package:collectio/model/collection.dart';
import 'package:collectio/model/collection_item.dart';
import 'package:collectio/model/user_profile.dart';
import 'package:collectio/util/constant/translation.dart';
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

    test(
      'should map Routes.newCollection to NewCollectionsScreen as fullscreen dialog',
      () {
        final String path = Routes.newCollection;
        final RouteSettings routeSettings = RouteSettings(name: path);

        final MaterialPageRoute result = Router.onGenerateRoute(routeSettings);

        expect(result.fullscreenDialog, isTrue);
        expect(result.builder(null), isA<NewCollectionScreen>());
      },
    );

    test(
      'should map Routes.collection to CollectionScreen with given collection for display',
      () {
        final String path = Routes.collection;
        final Collection collection = Collection(
          id: 'title',
          title: 'title',
          subtitle: 'subtitle',
          description: 'description',
          thumbnail: '',
          owner: 'username',
        );
        final RouteSettings routeSettings =
            RouteSettings(name: path, arguments: collection);

        final MaterialPageRoute result = Router.onGenerateRoute(routeSettings);

        expect(result.builder(null), isA<CollectionScreen>());
      },
    );

    test(
      'should map Routes.item to ItemDetailsScreen with given item for display',
      () {
        final String path = Routes.item;
        final CollectionItem item = CollectionItem(
          parent: Collection(
            id: 'title',
            owner: 'owner',
            title: 'title',
            subtitle: 'subtitle',
            description: 'description',
            thumbnail: null,
          ),
          id: 'title',
          title: 'title',
          subtitle: 'subtitle',
          description: 'description',
          imageUrl: '',
          added: null,
          raiting: 10,
          imageMetadata: null,
        );
        final RouteSettings routeSettings = RouteSettings(
          name: path,
          arguments: <String, dynamic>{
            'item': item,
            'itemNumber': 1,
            'numberOfItems': 1,
          },
        );

        final MaterialPageRoute result = Router.onGenerateRoute(routeSettings);

        expect(result.builder(null), isA<ItemDetailsScreen>());
      },
    );

    test('should map Routes.newItem to NewItemScreen with correct arguments',
        () {
      final String path = Routes.newItem;
      final Collection arguments = Collection(
        id: 'title',
        owner: 'owner',
        title: 'title',
        subtitle: 'subtitle',
        description: 'description',
        thumbnail: 'thumbnail',
      );
      final RouteSettings routeSettings =
          RouteSettings(name: path, arguments: arguments);

      final MaterialPageRoute result = Router.onGenerateRoute(routeSettings);
      final Widget screen = result.builder(null);

      expect(screen, isA<NewItemScreen>());

      NewItemScreen newItemScreen = screen as NewItemScreen;
      expect(newItemScreen.collection, arguments);
    });

    test('should map Routes.profile to ViewProfileScreen with correct argument',
        () {
      final String path = Routes.profile;
      final UserProfile argument = UserProfile(
        email: 'email@b.c',
        userUid: 'userUid',
        username: 'username',
      );
      final RouteSettings routeSettings =
          RouteSettings(name: path, arguments: argument);

      final MaterialPageRoute result = Router.onGenerateRoute(routeSettings);
      final Widget screen = result.builder(null);

      expect(screen, isA<ViewProfileScreen>());

      ViewProfileScreen viewProfileScreen = screen as ViewProfileScreen;
      expect(viewProfileScreen.profile, argument);
    });

    test('should map Routes.editProfile to EditProfileScreen', () {
      final String path = Routes.editProfile;
      final RouteSettings routeSettings = RouteSettings(name: path);

      final MaterialPageRoute result = Router.onGenerateRoute(routeSettings);
      final Widget screen = result.builder(null);

      expect(screen, isA<EditProfileScreen>());
    });

    test('should map Routes.settings to EditSettingsScreen', () {
      final String path = Routes.settings;
      final RouteSettings routeSettings = RouteSettings(name: path);

      final MaterialPageRoute result = Router.onGenerateRoute(routeSettings);
      final Widget screen = result.builder(null);

      expect(screen, isA<EditSettingsScreen>());
    });

    test('should map Routes.error to ErrorScreen with appropriate message', () {
      final String path = Routes.error;
      final Translation errorMessage = Translation.cancel;
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
      expect(errorScreen.errorMessage, equals(Translation.unknownRouteMessage));
    });
  });
}
