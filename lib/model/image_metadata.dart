import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:exif/exif.dart';
import 'package:meta/meta.dart';

class ImageMetadata extends Equatable {
  final DateTime created;
  final double latitude;
  final double longitude;

  static const String _dateTag = 'Image DateTime';
  static const String _latitude = 'GPS GPSLatitude';
  static const String _latitudeDirection = 'GPS GPSLatitudeRef';
  static const String _longitude = 'GPS GPSLongitude';
  static const String _longitudeDirection = 'GPS GPSLongitudeRef';

  ImageMetadata({
    @required this.created,
    @required this.latitude,
    @required this.longitude,
  });

  factory ImageMetadata.fromExif(Map<String, IfdTag> exif) => ImageMetadata(
        created: DateTime.parse(
          exif[_dateTag]
              .toString()
              .replaceAll(' ', 'T')
              .replaceFirst(':', '-')
              .replaceFirst(':', '-'),
        ),
        latitude: _parseLatLong(
          exifDynamicGeoList: exif[_latitude].values,
          direction: exif[_latitudeDirection].toString(),
        ),
        longitude: _parseLatLong(
          exifDynamicGeoList: exif[_longitude].values,
          direction: exif[_longitudeDirection].toString(),
        ),
      );

  factory ImageMetadata.fromJson(Map<String, dynamic> json) => ImageMetadata(
        created: json['created'] != null
            ? DateTime.fromMillisecondsSinceEpoch(json['created'])
            : null,
        latitude: json['latitude'],
        longitude: json['longitude'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'created': created?.millisecondsSinceEpoch,
        'latitude': latitude,
        'longitude': longitude,
      };

  static double _parseLatLong({
    @required List<dynamic> exifDynamicGeoList,
    @required String direction,
  }) {
    final List<Ratio> exifGeoList =
        exifDynamicGeoList.map((dynamic e) => e as Ratio).toList();
    double result = 0;

    for (int i = 0; i < exifGeoList.length; i++) {
      result +=
          exifGeoList[i].numerator / exifGeoList[i].denominator / pow(60, i);
    }

    return direction == 'S' || direction == 'W' ? -result : result;
  }

  @override
  List<Object> get props =>
      [created.toString().substring(0, 19), latitude, longitude];
}
