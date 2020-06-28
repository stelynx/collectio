abstract class MapsFacade {
  Future<List<String>> getLocationsForLatLng(
    double latitude,
    double longitude, {
    String language,
  });

  Future<List<String>> getSuggestionsFor(
    String searchQuery, {
    String languageCode,
    double latitude,
    double longitude,
  });
}
