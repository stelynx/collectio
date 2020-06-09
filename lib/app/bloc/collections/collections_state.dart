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
  final List<Collection> displayedCollections;
  final String toastMessage;
  final bool isSearching;

  const LoadedCollectionsState({
    @required this.collections,
    List<Collection> displayedCollections,
    this.toastMessage,
    this.isSearching = false,
  }) : displayedCollections = displayedCollections ?? collections;

  @override
  List<Object> get props => [
        collections,
        displayedCollections,
        isSearching,
      ];
}

class ErrorCollectionsState extends CollectionsState {}

class EmptyCollectionsState extends CollectionsState {}
