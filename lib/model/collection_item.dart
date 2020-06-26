import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'collection.dart';
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
  final ImageMetadata imageMetadata;

  String get thumbnail => imageUrl;

  CollectionItem({
    this.parent,
    this.id,
    @required this.added,
    @required this.title,
    @required this.subtitle,
    @required this.description,
    @required this.imageUrl,
    @required this.raiting,
    @required this.imageMetadata,
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
      ];
}
