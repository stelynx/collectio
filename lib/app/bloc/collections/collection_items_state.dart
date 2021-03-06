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
  final List<CollectionItem> displayedCollectionItems;
  final Translation toastMessage;
  final ToastType toastType;
  final bool isSearching;

  const LoadedCollectionItemsState({
    @required this.collectionItems,
    List<CollectionItem> displayedCollectionItems,
    this.toastMessage,
    this.toastType,
    this.isSearching = false,
  }) : displayedCollectionItems = displayedCollectionItems ?? collectionItems;

  @override
  List<Object> get props => [
        collectionItems,
        displayedCollectionItems,
        isSearching,
        toastMessage,
        toastType,
      ];
}

class ErrorCollectionItemsState extends CollectionItemsState {}
