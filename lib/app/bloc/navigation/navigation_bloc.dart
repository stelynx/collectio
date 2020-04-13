import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../util/constant/constants.dart';
import '../../routes/routes.dart';

part 'navigation_event.dart';

@prod
@lazySingleton
class NavigationBloc extends Bloc<NavigationEvent, void> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  void get initialState => null;

  @override
  Stream<void> mapEventToState(
    NavigationEvent event,
  ) async* {
    if (event is InitialNavigationEvent)
      _navigatorKey.currentState.pushNamed(Routes.initial);
    else if (event is GoToSignInScreenNavigationEvent)
      _navigatorKey.currentState.pushReplacementNamed(Routes.signIn);
    else if (event is GoToHomeScreenAfterSignInNavigationEvent)
      _navigatorKey.currentState
          .pushReplacementNamed(Routes.error, arguments: 'Not yet implemented');
    else
      _navigatorKey.currentState
          .pushNamed(Routes.error, arguments: Constants.unknownRouteMessage);
  }
}
