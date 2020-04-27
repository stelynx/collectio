import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'interface/listable.dart';

class CollectionItem extends Equatable implements Listable {
  final String id;
  final DateTime added;
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final int raiting;

  String get thumbnail => imageUrl;

  CollectionItem({
    @required this.id,
    @required this.added,
    @required this.title,
    @required this.subtitle,
    @required this.description,
    @required this.imageUrl,
    @required this.raiting,
  });

  factory CollectionItem.fromJson(Map<String, dynamic> json) => CollectionItem(
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

  @override
  List<Object> get props => [
        id,
        added.millisecondsSinceEpoch,
        title,
        subtitle,
        description,
        imageUrl,
        raiting,
      ];
}
