import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

import '../../../util/constant/collectio_theme.dart';
import '../../theme/theme.dart';
import '../auth/auth_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

@prod
@lazySingleton
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final AuthBloc _authBloc;
  StreamSubscription _authBlocStreamSubscription;

  ThemeBloc({@required AuthBloc authBloc}) : _authBloc = authBloc {
    _authBlocStreamSubscription = _authBloc.listen((AuthState state) {
      if (state is AuthenticatedAuthState) {
        // TODO get settings of user and his theme
        this.add(ChangeThemeEvent(CollectioTheme.LIGHT));
      } else {
        // TODO get system theme
        this.add(ChangeThemeEvent(CollectioTheme.DARK));
      }
    });
  }

  @override
  Future<void> close() {
    _authBlocStreamSubscription.cancel();
    return super.close();
  }

  @override
  ThemeState get initialState {
    if (_authBloc.state is AuthenticatedAuthState) {
      // TODO read from user's settings which theme to take
      return InitialThemeState(themeType: CollectioTheme.LIGHT);
    }

    // TODO otherwise get system theme
    return InitialThemeState(themeType: CollectioTheme.DARK);
  }

  @override
  Stream<ThemeState> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is ChangeThemeEvent) {
      yield GeneralThemeState(themeType: event.theme);
    }
  }
}

@test
@lazySingleton
@RegisterAs(ThemeBloc)
class MockedThemeBloc extends Mock implements ThemeBloc {}
