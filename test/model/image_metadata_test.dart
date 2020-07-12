import 'package:collectio/model/image_metadata.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final DateTime now = DateTime.now();
  final Map<String, dynamic> imageMetadataJson = <String, dynamic>{
    'created': now.millisecondsSinceEpoch,
    'latitude': 1.0,
    'longitude': 2.0,
  };
  final ImageMetadata imageMetadata = ImageMetadata(
    created: now,
    latitude: 1.0,
    longitude: 2.0,
  );

  test('should be able to create ImageMetadata from json', () {
    expect(ImageMetadata.fromJson(imageMetadataJson), equals(imageMetadata));
  });

  test('should be able to create json from ImageMetadata', () {
    expect(imageMetadata.toJson(), equals(imageMetadataJson));
  });
}
