part of 'new_item_bloc.dart';

abstract class NewItemEvent {
  const NewItemEvent();
}

class InitializeNewItemEvent extends NewItemEvent {
  final String owner;
  final String collection;

  const InitializeNewItemEvent(
      {@required this.owner, @required this.collection});
}

class TitleChangedNewItemEvent extends NewItemEvent {
  final String title;

  const TitleChangedNewItemEvent(this.title);
}

class SubtitleChangedNewItemEvent extends NewItemEvent {
  final String subtitle;

  const SubtitleChangedNewItemEvent(this.subtitle);
}

class DescriptionChangedNewItemEvent extends NewItemEvent {
  final String description;

  const DescriptionChangedNewItemEvent(this.description);
}

class RaitingChangedNewItemEvent extends NewItemEvent {
  final int raiting;

  const RaitingChangedNewItemEvent(this.raiting);
}

class SubmitNewItemEvent extends NewItemEvent {}
