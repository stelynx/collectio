import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'collection.dart';
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
          raiting: json['raiting']);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'added': added.millisecondsSinceEpoch,
        'title': title,
        'subtitle': subtitle,
        'description': description,
        'image': imageUrl,
        'raiting': raiting,
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
