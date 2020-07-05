import '../../model/geo_data.dart';

abstract class MapsFacade {
  Future<List<GeoData>> getLocationsForLatLng(
    double latitude,
    double longitude, {
    String language,
  });

  Future<List<GeoData>> getSuggestionsFor(
    String searchQuery, {
    String languageCode,
    double latitude,
    double longitude,
  });

  Future<GeoData> getPlaceDetails(String placeId);
}
