import 'package:bloc_test/bloc_test.dart';
import 'package:collectio/app/bloc/collections/collections_bloc.dart';
import 'package:collectio/app/bloc/profile/profile_bloc.dart';
import 'package:collectio/facade/collections/collections_facade.dart';
import 'package:collectio/facade/collections/firebase/firebase_collections_facade.dart';
import 'package:collectio/model/collection.dart';
import 'package:collectio/util/error/data_failure.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';
import '../../../mocks.dart';

void main() {
  configureInjection(Environment.test);
  final String username = 'username';
  final List<Collection> collections = [
    Collection.fromJson(
      {
        'id': 'id',
        'owner': 'owner',
        'title': 'title',
        'subtitle': 'subtitle',
        'thumbnail': 'thumbnail',
        'description': 'description',
      },
    ),
  ];
  final MockedFirebaseCollectionsFacade mockedFirebaseCollectionsFacade =
      getIt<CollectionsFacade>();
  final MockedProfileBloc mockedProfileBloc = getIt<ProfileBloc>();
  tearDownAll(() {
    mockedProfileBloc.close();
  });
  blocTest(
    'should emit Loading and Loaded on success',
    build: () async {
      when(mockedProfileBloc.listen(any))
          .thenReturn(MockedStreamSubscription<ProfileState>());
      when(mockedFirebaseCollectionsFacade.getCollectionsForUser(username))
          .thenAnswer((_) async => Right(collections));
      return CollectionsBloc(
        collectionsFacade: mockedFirebaseCollectionsFacade,
        profileBloc: mockedProfileBloc,
      );
    },
    act: (CollectionsBloc bloc) async =>
        bloc.add(GetCollectionsEvent(username: username)),
    expect: [
      LoadingCollectionsState(),
      LoadedCollectionsState(collections: collections),
    ],
  );
  blocTest(
    'should emit Loading and Error on failure',
    build: () async {
      when(mockedProfileBloc.listen(any))
          .thenReturn(MockedStreamSubscription<ProfileState>());
      when(mockedFirebaseCollectionsFacade.getCollectionsForUser(username))
          .thenAnswer((_) async => Left(DataFailure()));
      return CollectionsBloc(
        collectionsFacade: mockedFirebaseCollectionsFacade,
        profileBloc: mockedProfileBloc,
      );
    },
    act: (CollectionsBloc bloc) async =>
        bloc.add(GetCollectionsEvent(username: username)),
    expect: [
      LoadingCollectionsState(),
      ErrorCollectionsState(),
    ],
  );
}
