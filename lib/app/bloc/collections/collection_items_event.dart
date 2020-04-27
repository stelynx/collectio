part of 'collection_items_bloc.dart';

abstract class CollectionItemsEvent {
  const CollectionItemsEvent();
}

class GetCollectionItemsEvent extends CollectionItemsEvent {
  final String collectionOwner;
  final String collectionName;

  const GetCollectionItemsEvent(
      {@required this.collectionOwner, @required this.collectionName});
}
