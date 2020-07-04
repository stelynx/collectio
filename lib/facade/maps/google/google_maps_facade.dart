import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import '../../../model/geo_data.dart';
import '../../../service/maps_service.dart';
import '../../../util/constant/constants.dart';
import '../maps_facade.dart';

@prod
@lazySingleton
@RegisterAs(MapsFacade)
class GoogleMapsFacade extends MapsFacade {
  final MapsService _mapsService;

  GoogleMapsFacade({@required MapsService mapsService})
      : _mapsService = mapsService;

  @override
  Future<List<GeoData>> getLocationsForLatLng(
    double latitude,
    double longitude, {
    String language,
  }) async {
    if (latitude == null || longitude == null) return null;

    final http.Response response = await _mapsService.getLocationsForLatLng(
      latitude,
      longitude,
      languageCode: language,
    );

    if (response.statusCode != 200) {
      throw http.ClientException(response.statusCode.toString());
    }

    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (!jsonResponse.containsKey('results'))
      throw http.ClientException(response.statusCode.toString());

    return (jsonResponse['results'] as List)
        .map<GeoData>(
          (prediction) => GeoData(
            id: prediction['place_id'],
            location: prediction['formatted_address'],
            latitude: prediction['geometry']['location']['lat'],
            longitude: prediction['geometry']['location']['lng'],
          ),
        )
        .toList();
  }

  @override
  Future<List<GeoData>> getSuggestionsFor(
    String searchQuery, {
    String languageCode,
    double latitude,
    double longitude,
  }) async {
    if (searchQuery.length < Constants.minCharsForAutocomplete) return null;

    final http.Response response = await _mapsService.getSuggestionsFor(
      searchQuery,
      languageCode: languageCode,
      latitude: latitude,
      longitude: longitude,
    );

    if (response.statusCode != 200)
      throw http.ClientException(response.statusCode.toString());

    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (!jsonResponse.containsKey('predictions'))
      throw http.ClientException(response.statusCode.toString());

    return (jsonResponse['predictions'] as List)
        .map<GeoData>(
          (element) => GeoData(
            id: element['place_id'],
            location: element['description'],
          ),
        )
        .toList();
  }

  @override
  Future<GeoData> getPlaceDetails(String placeId) async {
    final http.Response placeDetailsResponse =
        await _mapsService.getPlaceDetails(placeId);

    if (placeDetailsResponse.statusCode != 200) return null;

    final Map<String, dynamic> placeDetailsResponseJson =
        json.decode(placeDetailsResponse.body);

    if (!placeDetailsResponseJson.containsKey('result')) return null;

    final Map<String, dynamic> placeDetailsJson =
        placeDetailsResponseJson['result'];

    if (!placeDetailsJson.containsKey('geometry') ||
        !(placeDetailsJson['geometry'] as Map).containsKey('location'))
      return null;

    return GeoData(
      id: placeDetailsJson['place_id'],
      location: placeDetailsJson['formatted_address'],
      latitude: placeDetailsJson['geometry']['location']['lat'],
      longitude: placeDetailsJson['geometry']['location']['lng'],
    );
  }
}

@test
@lazySingleton
@RegisterAs(MapsFacade)
class MockedGoogleMapsFacade extends Mock implements GoogleMapsFacade {}
