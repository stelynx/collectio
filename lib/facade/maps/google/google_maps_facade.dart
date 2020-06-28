import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import '../../../service/maps_service.dart';
import '../maps_facade.dart';

@prod
@lazySingleton
@RegisterAs(MapsFacade)
class GoogleMapsFacade extends MapsFacade {
  final MapsService _mapsService;

  GoogleMapsFacade({@required MapsService mapsService})
      : _mapsService = mapsService;

  @override
  Future<List<String>> getLocationsForLatLng(
    double latitude,
    double longitude, {
    String language,
  }) async {
    final http.Response response = await _mapsService.getLocationsForLatLng(
      latitude,
      longitude,
      languageCode: language,
    );

    if (response.statusCode != 200) {
      throw http.ClientException(response.statusCode.toString());
    }

    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (!jsonResponse.containsKey('predictions'))
      throw http.ClientException(response.statusCode.toString());

    return (jsonResponse['predictions'] as List)
        .map<String>((prediction) => prediction['description'])
        .toList();
  }

  @override
  Future<List<String>> getSuggestionsFor(
    String searchQuery, {
    String languageCode,
    double latitude,
    double longitude,
  }) async {
    final http.Response response = await _mapsService.getSuggestionsFor(
      searchQuery,
      languageCode: languageCode,
      latitude: latitude,
      longitude: longitude,
    );

    if (response.statusCode != 200)
      throw http.ClientException(response.statusCode.toString());

    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (!jsonResponse.containsKey('results'))
      throw http.ClientException(response.statusCode.toString());

    return (jsonResponse['results'] as List)
        .map<String>((element) => element['formatted_address'])
        .toList();
  }
}

@test
@lazySingleton
@RegisterAs(MapsFacade)
class MockedGoogleMapsFacade extends Mock implements GoogleMapsFacade {}
