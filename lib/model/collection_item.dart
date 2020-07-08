import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'collection.dart';
import 'geo_data.dart';
import 'image_metadata.dart';
import 'interface/listable.dart';

class CollectionItem extends Equatable implements Listable {
  final Collection parent;
  final String id;
  final DateTime added;
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final int raiting;
  final GeoData geoData;
  final ImageMetadata imageMetadata;

  String get thumbnail => imageUrl;
  bool get isPremium => false;

  CollectionItem({
    this.parent,
    this.id,
    @required this.added,
    @required this.title,
    @required this.subtitle,
    @required this.description,
    @required this.imageUrl,
    @required this.raiting,
    this.geoData,
    this.imageMetadata,
  });

  factory CollectionItem.fromJson(Map<String, dynamic> json,
          {Collection parent}) =>
      CollectionItem(
        parent: parent,
        id: json['id'],
        added: DateTime.fromMillisecondsSinceEpoch(json['added']),
        title: json['title'],
        subtitle: json['subtitle'],
        description: json['description'],
        imageUrl: json['image'],
        raiting: json['raiting'],
        geoData:
            json['geoData'] != null ? GeoData.fromJson(json['geoData']) : null,
        imageMetadata: json['imageMetadata'] != null
            ? ImageMetadata.fromJson(json['imageMetadata'])
            : null,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'added': added.millisecondsSinceEpoch,
        'title': title,
        'subtitle': subtitle,
        'description': description,
        'image': imageUrl,
        'raiting': raiting,
        'geoData': geoData != null ? geoData.toJson() : null,
        'imageMetadata': imageMetadata != null ? imageMetadata.toJson() : null,
      };

  static int compare(CollectionItem i1, CollectionItem i2) =>
      i2.added.compareTo(i1.added);

  @override
  List<Object> get props => [
        parent,
        id,
        title,
        subtitle,
        description,
        raiting,
        geoData,
      ];
}
