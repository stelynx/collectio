import 'dart:convert';

import 'package:collectio/facade/maps/google/google_maps_facade.dart';
import 'package:collectio/model/geo_data.dart';
import 'package:collectio/service/google/google_maps_service.dart';
import 'package:collectio/service/maps_service.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart' show Environment;
import 'package:mockito/mockito.dart';

import '../../../fixtures/google_autocomplete_response.dart';
import '../../../fixtures/google_geocode_response.dart';
import '../../../fixtures/google_place_details_response.dart';

void main() {
  configureInjection(Environment.test);

  GoogleMapsFacade googleMapsFacade;
  MockedGoogleMapsService mockedGoogleMapsService = getIt<MapsService>();

  setUp(() {
    googleMapsFacade = GoogleMapsFacade(mapsService: mockedGoogleMapsService);
  });

  group('getLocationsForLatLng', () {
    test('should return null if latitude is null', () async {
      final double latitude = null;
      final double longitude = 1;

      final List<GeoData> result =
          await googleMapsFacade.getLocationsForLatLng(latitude, longitude);

      expect(result, isNull);
    });

    test('should return null if longitude is null', () async {
      final double latitude = 1;
      final double longitude = null;

      final List<GeoData> result =
          await googleMapsFacade.getLocationsForLatLng(latitude, longitude);

      expect(result, isNull);
    });

    test('should call MapsService if latitude and longitude are given',
        () async {
      when(mockedGoogleMapsService.getLocationsForLatLng(any, any)).thenAnswer(
          (_) async => http.Response(json.encode(googleGeocodeResponse), 200));
      final double latitude = 1;
      final double longitude = 1;

      await googleMapsFacade.getLocationsForLatLng(latitude, longitude);

      verify(mockedGoogleMapsService.getLocationsForLatLng(latitude, longitude))
          .called(1);
    });

    test('should throw ClientException when response.code is not 200',
        () async {
      final int statusCode = 404;
      when(mockedGoogleMapsService.getLocationsForLatLng(any, any)).thenAnswer(
          (_) async =>
              http.Response(json.encode(googleGeocodeResponse), statusCode));
      final double latitude = 1;
      final double longitude = 1;

      expect(googleMapsFacade.getLocationsForLatLng(latitude, longitude),
          throwsA(isA<http.ClientException>()));
    });

    test('should throw ClientException when response body is wrong', () async {
      when(mockedGoogleMapsService.getLocationsForLatLng(any, any))
          .thenAnswer((_) async => http.Response('{}', 200));
      final double latitude = 1;
      final double longitude = 1;

      expect(googleMapsFacade.getLocationsForLatLng(latitude, longitude),
          throwsA(isA<http.ClientException>()));
    });

    test('should return List<GeoData> when everything is ok', () async {
      when(mockedGoogleMapsService.getLocationsForLatLng(any, any)).thenAnswer(
          (_) async => http.Response(json.encode(googleGeocodeResponse), 200));
      final double latitude = 1;
      final double longitude = 1;

      final result =
          await googleMapsFacade.getLocationsForLatLng(latitude, longitude);

      expect(result, isA<List<GeoData>>());
    });
  });

  group('getSuggestionsFor', () {
    test('should return null if query length is too short', () async {
      final String searchQuery = 'a';

      final List<GeoData> result =
          await googleMapsFacade.getSuggestionsFor(searchQuery);

      expect(result, isNull);
    });

    test('should call MapsService if query is long enough', () async {
      when(mockedGoogleMapsService.getSuggestionsFor(any)).thenAnswer(
          (_) async =>
              http.Response(json.encode(googleAutocompleteResponse), 200));
      final String searchQuery = 'abcd';

      await googleMapsFacade.getSuggestionsFor(searchQuery);

      verify(mockedGoogleMapsService.getSuggestionsFor(searchQuery)).called(1);
    });

    test('should throw ClientException when response.code is not 200',
        () async {
      final int statusCode = 404;
      final String searchQuery = 'abcd';
      when(mockedGoogleMapsService.getSuggestionsFor(any)).thenAnswer(
          (_) async => http.Response(
              json.encode(googleAutocompleteResponse), statusCode));

      expect(googleMapsFacade.getSuggestionsFor(searchQuery),
          throwsA(isA<http.ClientException>()));
    });

    test('should throw ClientException when response body is wrong', () async {
      final String searchQuery = 'abcd';
      when(mockedGoogleMapsService.getSuggestionsFor(any))
          .thenAnswer((_) async => http.Response('{}', 200));

      expect(googleMapsFacade.getSuggestionsFor(searchQuery),
          throwsA(isA<http.ClientException>()));
    });

    test('should return List<GeoData> when everything is ok', () async {
      when(mockedGoogleMapsService.getSuggestionsFor(any)).thenAnswer(
          (_) async =>
              http.Response(json.encode(googleAutocompleteResponse), 200));
      final String searchQuery = 'abcd';

      final result = await googleMapsFacade.getSuggestionsFor(searchQuery);

      expect(result, isA<List<GeoData>>());
    });
  });

  group('getPlaceDetails', () {
    test('should call MapsService', () async {
      when(mockedGoogleMapsService.getPlaceDetails(any)).thenAnswer((_) async =>
          http.Response(json.encode(googlePlaceDetailsResponse), 200));
      final String placeId = 'id';

      await googleMapsFacade.getPlaceDetails(placeId);

      verify(mockedGoogleMapsService.getPlaceDetails(placeId)).called(1);
    });

    test('should return null when response.code is not 200', () async {
      final int statusCode = 404;
      final String placeId = 'id';
      when(mockedGoogleMapsService.getPlaceDetails(any)).thenAnswer((_) async =>
          http.Response(json.encode(googlePlaceDetailsResponse), statusCode));

      final GeoData result = await googleMapsFacade.getPlaceDetails(placeId);

      expect(result, isNull);
    });

    test('should return null when response body does not contain "result"',
        () async {
      final String placeId = 'id';
      when(mockedGoogleMapsService.getPlaceDetails(any))
          .thenAnswer((_) async => http.Response('{}', 200));

      final GeoData result = await googleMapsFacade.getPlaceDetails(placeId);

      expect(result, isNull);
    });

    test('should return null when response body "result" is wrong', () async {
      final String placeId = 'id';
      when(mockedGoogleMapsService.getPlaceDetails(any))
          .thenAnswer((_) async => http.Response('{"result": {}}', 200));

      final GeoData result = await googleMapsFacade.getPlaceDetails(placeId);

      expect(result, isNull);
    });

    test('should return GeoData when everything is ok', () async {
      when(mockedGoogleMapsService.getPlaceDetails(any)).thenAnswer((_) async =>
          http.Response(json.encode(googlePlaceDetailsResponse), 200));
      final String placeId = 'placeId';

      final result = await googleMapsFacade.getPlaceDetails(placeId);

      expect(result, isA<GeoData>());
    });
  });
}
