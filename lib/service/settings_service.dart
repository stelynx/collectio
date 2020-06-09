import 'package:meta/meta.dart';

abstract class SettingsService {
  /// Gets settings for user with [username].
  Future<Map<String, dynamic>> getSettingsForUser({@required String username});

  /// Sets [settings] for user with [username].
  Future<void> setSettingsForUser(
      {@required String username, @required Map<String, dynamic> settings});
}
