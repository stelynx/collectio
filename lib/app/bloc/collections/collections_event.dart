part of 'collections_bloc.dart';

@immutable
abstract class CollectionsEvent {
  const CollectionsEvent();
}

class GetCollectionsEvent extends CollectionsEvent {
  final String username;

  const GetCollectionsEvent({@required this.username});
}
