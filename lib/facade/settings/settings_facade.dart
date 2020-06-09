import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../model/settings.dart';
import '../../service/settings_service.dart';
import '../../util/error/data_failure.dart';

abstract class SettingsFacade {
  SettingsService settingsService;

  /// Gets settings for user with [username].
  Future<Either<DataFailure, Settings>> getSettings(
      {@required String username});

  /// Updates [settings] for user with [username].
  Future<Either<DataFailure, void>> updateSettings(
      {@required String username, @required Settings settings});
}
