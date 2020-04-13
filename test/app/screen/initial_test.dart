import 'package:bloc_test/bloc_test.dart';
import 'package:collectio/app/bloc/auth/auth_bloc.dart';
import 'package:collectio/app/screen/initial.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;

void main() {
  configureInjection(Environment.test);

  AuthBloc mockedAuthBloc;

  Widget makeTestableWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => mockedAuthBloc,
        ),
      ],
      child: MaterialApp(
        home: InitialScreen(),
      ),
    );
  }

  setUp(() {
    mockedAuthBloc = getIt<AuthBloc>();
  });

  testWidgets(
    'should show circular progress indicator on start',
    (WidgetTester tester) async {
      final List<AuthState> states = [InitialAuthState()];
      whenListen(mockedAuthBloc, Stream.fromIterable(states));

      final Finder cpiFinder = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(makeTestableWidget());

      expect(cpiFinder, findsOneWidget);
    },
  );
}
