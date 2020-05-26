import 'package:collectio/app/screen/profile/view_profile/view_profile_screen.dart';
import 'package:collectio/model/user_profile.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart';

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
}
