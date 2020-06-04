import 'package:bloc_test/bloc_test.dart';
import 'package:collectio/app/bloc/auth/auth_bloc.dart';
import 'package:collectio/app/bloc/theme/theme_bloc.dart';
import 'package:collectio/util/constant/collectio_theme.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;
import 'package:mockito/mockito.dart';

import '../../../mocks.dart';

void main() {
  configureInjection(Environment.test);

  final AuthBloc authBloc = getIt<AuthBloc>();

  tearDownAll(() {
    authBloc.close();
  });

  blocTest(
    'should yield a state with selected theme',
    build: () async {
      when(authBloc.listen(any))
          .thenReturn(MockedStreamSubscription<AuthState>());
      when(authBloc.state)
          .thenReturn(AuthenticatedAuthState(userUid: 'userUid'));
      return ThemeBloc(authBloc: authBloc);
    },
    act: (ThemeBloc bloc) async =>
        bloc.add(ChangeThemeEvent(CollectioTheme.LIGHT)),
    expect: [
      GeneralThemeState(themeType: CollectioTheme.LIGHT),
    ],
  );
}
