import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class GeoData extends Equatable {
  final String id;
  final String location;
  final double latitude;
  final double longitude;

  const GeoData({
    @required this.id,
    @required this.location,
    this.latitude,
    this.longitude,
  });

  factory GeoData.fromJson(Map<String, dynamic> json) => GeoData(
      id: json['id'],
      location: json['location'],
      latitude: json['latitude'],
      longitude: json['longitude']);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
      };

  @override
  List<Object> get props => [id, location, latitude, longitude];

  @override
  String toString() => location;
}
