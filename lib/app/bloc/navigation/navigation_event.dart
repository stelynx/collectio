part of 'navigation_bloc.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class InitialNavigationEvent extends NavigationEvent {}

class GoToSignInScreenNavigationEvent extends NavigationEvent {}

class GoToHomeScreenAfterSignInNavigationEvent extends NavigationEvent {}
