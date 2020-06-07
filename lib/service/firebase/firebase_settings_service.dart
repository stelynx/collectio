import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';

import '../../util/constant/constants.dart';
import '../settings_service.dart';

@prod
@lazySingleton
@RegisterAs(SettingsService)
class FirebaseSettingsService extends SettingsService {
  final Firestore _firestore;

  FirebaseSettingsService({@required Firestore firestore})
      : _firestore = firestore;

  @override
  Future<Map<String, dynamic>> getSettingsForUser({
    @required String username,
  }) async =>
      (await _firestore
              .collection(Constants.settingsCollection)
              .document(username)
              .get())
          .data;

  @override
  Future<void> setSettingsForUser({
    @required String username,
    @required Map<String, dynamic> settings,
  }) =>
      _firestore
          .collection(Constants.settingsCollection)
          .document(username)
          .setData(settings);
}

@test
@lazySingleton
@RegisterAs(SettingsService)
class MockedFirebaseSettingsService extends Mock
    implements FirebaseSettingsService {}
