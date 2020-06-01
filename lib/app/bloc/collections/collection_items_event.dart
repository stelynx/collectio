part of 'collection_items_bloc.dart';

abstract class CollectionItemsEvent extends Equatable {
  const CollectionItemsEvent();
}

class GetCollectionItemsEvent extends CollectionItemsEvent {
  final Collection collection;

  const GetCollectionItemsEvent(this.collection);

  @override
  List<Object> get props => [collection];
}

class DeleteItemCollectionItemsEvent extends CollectionItemsEvent {
  final CollectionItem item;

  const DeleteItemCollectionItemsEvent(this.item);

  @override
  List<Object> get props => [item];
}
