import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import '../../../model/settings.dart';
import '../../../service/settings_service.dart';
import '../../../util/error/data_failure.dart';
import '../settings_facade.dart';

@prod
@lazySingleton
@RegisterAs(SettingsFacade)
class FirebaseSettingsFacade extends SettingsFacade {
  final SettingsService _settingsService;

  FirebaseSettingsFacade({@required SettingsService settingsService})
      : _settingsService = settingsService;

  @override
  Future<Either<DataFailure, Settings>> getSettings({
    @required String username,
  }) async {
    try {
      final Map<String, dynamic> settingsJson =
          await _settingsService.getSettingsForUser(username: username);

      return Right(Settings.fromJson(settingsJson));
    } catch (_) {
      return Left(DataFailure());
    }
  }

  @override
  Future<Either<DataFailure, void>> updateSettings({
    @required String username,
    @required Settings settings,
  }) async {
    try {
      await _settingsService.setSettingsForUser(
        username: username,
        settings: settings.toJson(),
      );

      return Right(null);
    } catch (_) {
      return Left(DataFailure());
    }
  }
}

@test
@lazySingleton
@RegisterAs(SettingsFacade)
class MockedFirebaseSettingsFacade extends Mock
    implements FirebaseSettingsFacade {}
