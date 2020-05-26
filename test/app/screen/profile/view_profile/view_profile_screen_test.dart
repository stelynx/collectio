import 'package:bloc_test/bloc_test.dart';
import 'package:collectio/app/bloc/collections/collections_bloc.dart';
import 'package:collectio/app/screen/profile/view_profile/view_profile_screen.dart';
import 'package:collectio/model/collection.dart';
import 'package:collectio/model/user_profile.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  configureInjection(Environment.test);

  final UserProfile profile = UserProfile(
    email: 'email@b.c',
    userUid: 'userUid',
    username: 'username',
    firstName: 'firstName',
    lastName: 'lastName',
  );

  Widget makeTestableWidget() => MaterialApp(home: ViewProfileScreen(profile));

  testWidgets('should have a user profile card', (WidgetTester tester) async {
    await tester.pumpWidget(makeTestableWidget());

    final Finder cardFinder = find.byType(Card);

    expect(cardFinder, findsOneWidget);
  });

  testWidgets(
    'should have a list of collections when collections are loaded',
    (WidgetTester tester) async {
      mockNetworkImagesFor(() async {
        final Collection collection = Collection(
          id: 'title',
          owner: 'owner',
          title: 'title',
          subtitle: 'subtitle',
          description: 'description',
          thumbnail: 'thumbnail',
        );
        final List<CollectionsState> states = [
          InitialCollectionsState(),
          LoadedCollectionsState(collections: <Collection>[collection]),
        ];
        whenListen(getIt<CollectionsBloc>(), Stream.fromIterable(states));

        await tester.pumpWidget(makeTestableWidget());
        await tester.pump();

        final Finder collectionFinder = find.text(collection.title);

        expect(collectionFinder, findsOneWidget);
      });
    },
  );
}
