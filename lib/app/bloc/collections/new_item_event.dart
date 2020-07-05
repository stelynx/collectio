part of 'new_item_bloc.dart';

abstract class NewItemEvent {
  const NewItemEvent();
}

class InitializeNewItemEvent extends NewItemEvent {
  final Collection collection;

  const InitializeNewItemEvent(this.collection);
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

class ImageChangedNewItemEvent extends NewItemEvent {
  final File image;
  final ImageMetadata metadata;

  const ImageChangedNewItemEvent({
    @required this.image,
    @required this.metadata,
  });
}

class LocationChangedNewItemEvent extends NewItemEvent {
  final GeoData geoData;

  const LocationChangedNewItemEvent(this.geoData);
}

class SubmitNewItemEvent extends NewItemEvent {}
