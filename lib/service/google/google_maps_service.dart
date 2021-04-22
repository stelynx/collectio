import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import '../../util/constant/constants.dart';
import '../maps_service.dart';

@prod
@lazySingleton
@RegisterAs(MapsService)
class GoogleMapsService extends MapsService {
  final http.Client _httpClient;

  GoogleMapsService({
    @required http.Client httpClient,
  }) : _httpClient = httpClient;

  @override
  Future<http.Response> getLocationsForLatLng(
    double latitude,
    double longitude, {
    String languageCode,
  }) async {
    final String uri = '/json';

    final Map<String, String> params = <String, String>{
      'latlng': '$latitude,$longitude',
    };
    if (languageCode != null)
      params.putIfAbsent('language', () => languageCode);

    return await _requestGoogleApi(
        '${Constants.googleMapsGeocodingApiUrl}$uri', params);
  }

  @override
  Future<http.Response> getSuggestionsFor(
    String searchQuery, {
    String languageCode,
    double latitude,
    double longitude,
  }) async {
    final String uri = '/autocomplete/json';

    final Map<String, String> params = <String, String>{};
    params.putIfAbsent('input', () => searchQuery);
    if (languageCode != null)
      params.putIfAbsent('language', () => languageCode);
    if (latitude != null && longitude != null) {
      params.putIfAbsent(
        'location',
        () => '$latitude,$longitude',
      );
      params.putIfAbsent('radius', () => '10000');
    }

    return await _requestGoogleApi(
        '${Constants.googleMapsPlaceApiUrl}$uri', params);
  }

  @override
  Future<http.Response> getPlaceDetails(String placeId) async {
    if (placeId == null) throw ArgumentError.notNull('placeId');

    final String uri = '/details/json';

    final Map<String, String> params = <String, String>{
      'place_id': placeId,
    };

    return await _requestGoogleApi(
        '${Constants.googleMapsPlaceApiUrl}$uri', params);
  }

  Future<http.Response> _requestGoogleApi(
    String url,
    Map<String, String> params,
  ) async {
    url += '?key=${Constants.googleApiKey}';
    params
        .forEach((String key, String value) => url += '&' + key + '=' + value);

    return await _httpClient.get(url);
  }
}

@test
@lazySingleton
@RegisterAs(MapsService)
class MockedGoogleMapsService extends Mock implements GoogleMapsService {}
