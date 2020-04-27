part of 'collection_items_bloc.dart';

abstract class CollectionItemsState extends Equatable {
  const CollectionItemsState();

  @override
  List<Object> get props => [];
}

class InitialCollectionItemsState extends CollectionItemsState {}

class LoadedCollectionItemsState extends CollectionItemsState {
  final List<CollectionItem> collectionItems;

  const LoadedCollectionItemsState(this.collectionItems);

  @override
  List<Object> get props => [collectionItems];
}

class ErrorCollectionItemsState extends CollectionItemsState {}
