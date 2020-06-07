import 'package:meta/meta.dart';

abstract class SettingsService {
  Future<Map<String, dynamic>> getSettingsForUser({@required String username});

  Future<void> setSettingsForUser(
      {@required String username, @required Map<String, dynamic> settings});
}
