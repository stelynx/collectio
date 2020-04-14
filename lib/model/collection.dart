import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Collection extends Equatable {
  final String id; // this is also a name of the collection
  final String owner;
  final String title;
  final String subtitle;
  final String description;
  final String thumbnail;

  Collection({
    @required this.id,
    @required this.owner,
    @required this.title,
    @required this.subtitle,
    @required this.description,
    @required this.thumbnail,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'],
      owner: json['owner'],
      title: json['title'],
      subtitle: json['subtitle'],
      description: json['description'],
      thumbnail: json['thumbnail'],
    );
  }

  @override
  List<Object> get props =>
      [id, owner, title, subtitle, description, thumbnail];
}
