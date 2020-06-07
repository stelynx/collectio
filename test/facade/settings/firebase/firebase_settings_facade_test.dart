import 'package:collectio/facade/settings/firebase/firebase_settings_facade.dart';
import 'package:collectio/model/settings.dart';
import 'package:collectio/service/settings_service.dart';
import 'package:collectio/util/constant/collectio_theme.dart';
import 'package:collectio/util/error/data_failure.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;
import 'package:mockito/mockito.dart';

void main() {
  configureInjection(Environment.test);

  final String username = 'username';
  final Settings settings = Settings(theme: CollectioTheme.LIGHT);
  final Map<String, dynamic> settingsJson = settings.toJson();

  final SettingsService settingsService = getIt<SettingsService>();
  final FirebaseSettingsFacade firebaseSettingsFacade =
      FirebaseSettingsFacade(settingsService: settingsService);

  group('getSettings', () {
    test('should call SettingsService.getSettingsForUser', () async {
      when(settingsService.getSettingsForUser(username: anyNamed('username')))
          .thenAnswer((_) async => null);

      await firebaseSettingsFacade.getSettings(username: username);

      verify(settingsService.getSettingsForUser(username: username)).called(1);
    });

    test('should return Right(Settings) on success', () async {
      when(settingsService.getSettingsForUser(username: anyNamed('username')))
          .thenAnswer((_) async => settingsJson);

      final Either<DataFailure, Settings> result =
          await firebaseSettingsFacade.getSettings(username: username);

      expect(result, equals(Right(settings)));
    });

    test('should return Left(DataFailure) on any failure', () async {
      when(settingsService.getSettingsForUser(username: anyNamed('username')))
          .thenThrow(Exception());

      final Either<DataFailure, Settings> result =
          await firebaseSettingsFacade.getSettings(username: username);

      expect(result, equals(Left(DataFailure())));
    });
  });

  group('updateSettings', () {
    test('should call SettingsService.setSettingsForUser', () async {
      when(settingsService.setSettingsForUser(
        username: anyNamed('username'),
        settings: anyNamed('settings'),
      )).thenAnswer((_) async => null);

      await firebaseSettingsFacade.updateSettings(
        username: username,
        settings: settings,
      );

      verify(settingsService.setSettingsForUser(
        username: username,
        settings: settingsJson,
      )).called(1);
    });

    test('should return Right(null) on success', () async {
      when(settingsService.setSettingsForUser(
        username: anyNamed('username'),
        settings: anyNamed('settings'),
      )).thenAnswer((_) async => null);

      final Either<DataFailure, void> result =
          await firebaseSettingsFacade.updateSettings(
        username: username,
        settings: settings,
      );

      expect(result, equals(Right(null)));
    });

    test('should return Left(DataFailure) on any failure', () async {
      when(settingsService.setSettingsForUser(
        username: anyNamed('username'),
        settings: anyNamed('settings'),
      )).thenThrow(Exception());

      final Either<DataFailure, void> result =
          await firebaseSettingsFacade.updateSettings(
        username: username,
        settings: settings,
      );

      expect(result, equals(Left(DataFailure())));
    });
  });
}
