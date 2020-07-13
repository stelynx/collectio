import 'package:collectio/model/geo_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final GeoData geoData =
      GeoData(id: 'id', location: 'location', latitude: 1.0, longitude: 2.0);
  final Map<String, dynamic> geoDataJson = <String, dynamic>{
    'id': 'id',
    'location': 'location',
    'latitude': 1.0,
    'longitude': 2.0,
  };

  test('should be able to get GeoData object from json', () {
    expect(GeoData.fromJson(geoDataJson), equals(geoData));
  });

  test('should be able to create json from GeoData object', () {
    expect(geoData.toJson(), equals(geoDataJson));
  });

  test('should be able to equate two GeoData objects', () {
    final GeoData geoData2 =
        GeoData(id: 'id', location: 'location', latitude: 1.0, longitude: 2.0);

    expect(geoData2, equals(geoData));
  });

  test('should return location when converting to string', () {
    expect(geoData.toString(), equals(geoData.location));
  });
}
