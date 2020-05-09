part of 'new_collection_bloc.dart';

@immutable
abstract class NewCollectionEvent {
  const NewCollectionEvent();
}

class TitleChangedNewCollectionEvent extends NewCollectionEvent {
  final String title;

  const TitleChangedNewCollectionEvent(this.title);
}

class SubtitleChangedNewCollectionEvent extends NewCollectionEvent {
  final String subtitle;

  const SubtitleChangedNewCollectionEvent(this.subtitle);
}

class DescriptionChangedNewCollectionEvent extends NewCollectionEvent {
  final String description;

  const DescriptionChangedNewCollectionEvent(this.description);
}

class ImageChangedNewCollectionEvent extends NewCollectionEvent {
  final File image;

  const ImageChangedNewCollectionEvent(this.image);
}

class SubmitNewCollectionEvent extends NewCollectionEvent {}
