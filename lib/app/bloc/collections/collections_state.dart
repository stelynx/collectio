part of 'collections_bloc.dart';

@immutable
abstract class CollectionsState extends Equatable {
  const CollectionsState();

  @override
  List<Object> get props => [];
}

class InitialCollectionsState extends CollectionsState {}

class LoadingCollectionsState extends CollectionsState {}

class LoadedCollectionsState extends CollectionsState {
  final List<Collection> collections;
  final String toastMessage;

  const LoadedCollectionsState({@required this.collections, this.toastMessage});

  @override
  List<Object> get props => [collections];
}

class ErrorCollectionsState extends CollectionsState {}
