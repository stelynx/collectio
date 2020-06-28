import 'package:http/http.dart' as http;

abstract class MapsService {
  /// Returns list of location descriptions for given [latitude] and [longitude].
  Future<http.Response> getLocationsForLatLng(
    double latitude,
    double longitude, {
    String languageCode,
  });

  /// Returns autocomplete suggestions for given [searchQuery].
  Future<http.Response> getSuggestionsFor(
    String searchQuery, {
    String languageCode,
    double latitude,
    double longitude,
  });
}
