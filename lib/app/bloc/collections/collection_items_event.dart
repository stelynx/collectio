part of 'collection_items_bloc.dart';

abstract class CollectionItemsEvent extends Equatable {
  const CollectionItemsEvent();
}

class GetCollectionItemsEvent extends CollectionItemsEvent {
  final String collectionOwner;
  final String collectionName;

  const GetCollectionItemsEvent(
      {@required this.collectionOwner, @required this.collectionName});

  @override
  List<Object> get props => [collectionOwner, collectionName];
}

class DeleteItemCollectionItemsEvent extends CollectionItemsEvent {
  final CollectionItem item;

  const DeleteItemCollectionItemsEvent(this.item);

  @override
  List<Object> get props => [item];
}
