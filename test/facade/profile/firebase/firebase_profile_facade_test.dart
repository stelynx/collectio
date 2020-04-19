import 'package:collectio/facade/profile/firebase/firebase_profile_facade.dart';
import 'package:collectio/model/user_profile.dart';
import 'package:collectio/service/data_service.dart';
import 'package:collectio/util/constant/constants.dart';
import 'package:collectio/util/error/data_failure.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart' show Environment;
import 'package:mockito/mockito.dart';

import '../../../mocks.dart';

void main() {
  configureInjection(Environment.test);

  final UserProfile userProfile = UserProfile(
    email: 'email',
    userUid: 'userUid',
    username: 'username',
  );
  final Map<String, dynamic> userProfileJson = userProfile.toJson();

  FirebaseProfileFacade firebaseProfileFacade;

  setUp(() {
    firebaseProfileFacade =
        FirebaseProfileFacade(dataService: getIt<DataService>());
  });

  group('addUserProfile', () {
    test('should call data service with correct arguments', () async {
      when(firebaseProfileFacade.dataService.addUserProfile(
        id: anyNamed('id'),
        userProfile: anyNamed('userProfile'),
      )).thenAnswer((_) async => null);

      await firebaseProfileFacade.addUserProfile(userProfile: userProfile);

      verify(firebaseProfileFacade.dataService.addUserProfile(
        id: userProfile.username,
        userProfile: userProfileJson,
      )).called(1);
    });

    test('should return Right(null) on success', () async {
      when(firebaseProfileFacade.dataService.addUserProfile(
        id: anyNamed('id'),
        userProfile: anyNamed('userProfile'),
      )).thenAnswer((_) async => null);

      final Either<DataFailure, void> result =
          await firebaseProfileFacade.addUserProfile(userProfile: userProfile);

      expect(result, equals(Right(null)));
    });

    test('should return Left(DataFailure) on success', () async {
      when(firebaseProfileFacade.dataService.addUserProfile(
        id: anyNamed('id'),
        userProfile: anyNamed('userProfile'),
      )).thenThrow(Exception());

      final Either<DataFailure, void> result =
          await firebaseProfileFacade.addUserProfile(userProfile: userProfile);

      expect(
          result, equals(Left(DataFailure(message: Exception().toString()))));
    });
  });

  group('getUserProfileByUsername', () {
    final String username = 'username';

    test('should call data service with correct arguments', () async {
      when(firebaseProfileFacade.dataService
              .getUserProfileByUsername(username: anyNamed('username')))
          .thenAnswer((_) async => null);

      await firebaseProfileFacade.getUserProfileByUsername(username: username);

      verify(firebaseProfileFacade.dataService
              .getUserProfileByUsername(username: username))
          .called(1);
    });

    test('should return Right(UserProfile) on success', () async {
      when(firebaseProfileFacade.dataService
              .getUserProfileByUsername(username: anyNamed('username')))
          .thenAnswer((_) async => MockedQuerySnapshot(
              [MockedDocumentSnapshot(username, userProfileJson)]));

      final Either<DataFailure, UserProfile> result =
          await firebaseProfileFacade.getUserProfileByUsername(
              username: username);

      expect(result, equals(Right(userProfile)));
    });

    test(
        'should return Left(DataFailure) with appropriate message when 0 matches',
        () async {
      when(firebaseProfileFacade.dataService
              .getUserProfileByUsername(username: anyNamed('username')))
          .thenAnswer((_) async => MockedQuerySnapshot([]));

      final Either<DataFailure, UserProfile> result =
          await firebaseProfileFacade.getUserProfileByUsername(
              username: username);

      expect(
        result,
        equals(Left(DataFailure(message: Constants.notExactlyOneObjectFound))),
      );
    });

    test(
        'should return Left(DataFailure) with appropriate message when 2+ matches',
        () async {
      when(firebaseProfileFacade.dataService
              .getUserProfileByUsername(username: anyNamed('username')))
          .thenAnswer(
        (_) async => MockedQuerySnapshot([
          MockedDocumentSnapshot(username, userProfileJson),
          MockedDocumentSnapshot(username, userProfileJson),
        ]),
      );

      final Either<DataFailure, UserProfile> result =
          await firebaseProfileFacade.getUserProfileByUsername(
              username: username);

      expect(
        result,
        equals(Left(DataFailure(message: Constants.notExactlyOneObjectFound))),
      );
    });

    test('should return Left(DataFailure) on exception', () async {
      when(firebaseProfileFacade.dataService
              .getUserProfileByUsername(username: anyNamed('username')))
          .thenThrow(Exception());

      final Either<DataFailure, UserProfile> result =
          await firebaseProfileFacade.getUserProfileByUsername(
              username: username);

      expect(
        result,
        equals(Left(DataFailure(message: Exception().toString()))),
      );
    });
  });

  group('getUserProfileByUserUid', () {
    final String userUid = 'userUid';

    test('should call data service with correct arguments', () async {
      when(firebaseProfileFacade.dataService
              .getUserProfileByUserUid(userUid: anyNamed('userUid')))
          .thenAnswer((_) async => null);

      await firebaseProfileFacade.getUserProfileByUserUid(userUid: userUid);

      verify(firebaseProfileFacade.dataService
              .getUserProfileByUserUid(userUid: userUid))
          .called(1);
    });

    test('should return Right(UserProfile) on success', () async {
      when(firebaseProfileFacade.dataService
              .getUserProfileByUserUid(userUid: anyNamed('userUid')))
          .thenAnswer((_) async => MockedQuerySnapshot(
              [MockedDocumentSnapshot(userUid, userProfileJson)]));

      final Either<DataFailure, UserProfile> result =
          await firebaseProfileFacade.getUserProfileByUserUid(userUid: userUid);

      expect(result, equals(Right(userProfile)));
    });

    test(
        'should return Left(DataFailure) with appropriate message when 0 matches',
        () async {
      when(firebaseProfileFacade.dataService
              .getUserProfileByUserUid(userUid: anyNamed('userUid')))
          .thenAnswer((_) async => MockedQuerySnapshot([]));

      final Either<DataFailure, UserProfile> result =
          await firebaseProfileFacade.getUserProfileByUserUid(userUid: userUid);

      expect(
        result,
        equals(Left(DataFailure(message: Constants.notExactlyOneObjectFound))),
      );
    });

    test(
        'should return Left(DataFailure) with appropriate message when 2+ matches',
        () async {
      when(firebaseProfileFacade.dataService
              .getUserProfileByUserUid(userUid: anyNamed('userUid')))
          .thenAnswer(
        (_) async => MockedQuerySnapshot([
          MockedDocumentSnapshot(userUid, userProfileJson),
          MockedDocumentSnapshot(userUid, userProfileJson),
        ]),
      );

      final Either<DataFailure, UserProfile> result =
          await firebaseProfileFacade.getUserProfileByUserUid(userUid: userUid);

      expect(
        result,
        equals(Left(DataFailure(message: Constants.notExactlyOneObjectFound))),
      );
    });

    test('should return Left(DataFailure) on exception', () async {
      when(firebaseProfileFacade.dataService
              .getUserProfileByUserUid(userUid: anyNamed('userUid')))
          .thenThrow(Exception());

      final Either<DataFailure, UserProfile> result =
          await firebaseProfileFacade.getUserProfileByUserUid(userUid: userUid);

      expect(
        result,
        equals(Left(DataFailure(message: Exception().toString()))),
      );
    });
  });
}
