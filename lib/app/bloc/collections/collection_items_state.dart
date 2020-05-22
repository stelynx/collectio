part of 'collection_items_bloc.dart';

abstract class CollectionItemsState extends Equatable {
  const CollectionItemsState();

  @override
  List<Object> get props => [];
}

class InitialCollectionItemsState extends CollectionItemsState {}

class LoadingCollectionItemsState extends CollectionItemsState {}

class LoadedCollectionItemsState extends CollectionItemsState {
  final List<CollectionItem> collectionItems;
  final String toastMessage;

  const LoadedCollectionItemsState(this.collectionItems, {this.toastMessage});

  @override
  List<Object> get props => [collectionItems];
}

class ErrorCollectionItemsState extends CollectionItemsState {}
