import 'package:collectio/app/screen/auth/sign_in.dart';
import 'package:collectio/app/screen/auth/widgets/sign_in_form.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;

void main() {
  configureInjection(Environment.prod);

  Widget makeTestableWidget() => MaterialApp(home: SignInScreen());

  testWidgets(
    'should have a Scaffold with SignInForm in body',
    (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget());

      final Finder scaffoldFinder = find.byType(Scaffold);
      expect(scaffoldFinder, findsOneWidget);

      final Finder sifFinder = find.byType(SignInForm);
      expect(sifFinder, findsOneWidget);
    },
  );
}
