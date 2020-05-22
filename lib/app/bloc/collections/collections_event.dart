part of 'collections_bloc.dart';

@immutable
abstract class CollectionsEvent extends Equatable {
  const CollectionsEvent();
}

class GetCollectionsEvent extends CollectionsEvent {
  final String username;

  const GetCollectionsEvent({@required this.username});

  @override
  List<Object> get props => [username];
}

class DeleteCollectionCollectionsEvent extends CollectionsEvent {
  final Collection collection;

  const DeleteCollectionCollectionsEvent(this.collection);

  @override
  List<Object> get props => [collection];
}
