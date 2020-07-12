import 'dart:convert';

import 'package:collectio/service/google/google_maps_service.dart';
import 'package:collectio/util/injection/injectable_http_module.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart' show Environment;
import 'package:mockito/mockito.dart';

import '../../fixtures/google_autocomplete_response.dart';
import '../../fixtures/google_geocode_response.dart';
import '../../fixtures/google_place_details_response.dart';

void main() {
  configureInjection(Environment.test);

  final MockedHttpClient mockedHttpClient = getIt<http.Client>();
  final GoogleMapsService googleMapsService =
      GoogleMapsService(httpClient: mockedHttpClient);

  test('should return response to getLocationsForLatLng', () async {
    when(mockedHttpClient.get(any)).thenAnswer(
        (_) async => http.Response(json.encode(googleGeocodeResponse), 200));

    final http.Response result =
        await googleMapsService.getLocationsForLatLng(1.0, 1.0);

    expect(result, isA<http.Response>());
  });

  test('should return response to getSuggestionsFor', () async {
    when(mockedHttpClient.get(any)).thenAnswer((_) async =>
        http.Response(json.encode(googleAutocompleteResponse), 200));

    final http.Response result =
        await googleMapsService.getSuggestionsFor('ljubljana');

    expect(result, isA<http.Response>());
  });

  test('should return response to getPlaceDetails', () async {
    when(mockedHttpClient.get(any)).thenAnswer((_) async =>
        http.Response(json.encode(googlePlaceDetailsResponse), 200));

    final http.Response result =
        await googleMapsService.getPlaceDetails('placeId');

    expect(result, isA<http.Response>());
  });
}
