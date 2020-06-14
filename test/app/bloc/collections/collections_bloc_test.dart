import 'package:bloc_test/bloc_test.dart';
import 'package:collectio/app/bloc/collections/collections_bloc.dart';
import 'package:collectio/app/bloc/profile/profile_bloc.dart';
import 'package:collectio/app/widgets/collectio_toast.dart';
import 'package:collectio/facade/collections/collections_facade.dart';
import 'package:collectio/facade/collections/firebase/firebase_collections_facade.dart';
import 'package:collectio/model/collection.dart';
import 'package:collectio/util/constant/constants.dart';
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
  final Collection collection = Collection.fromJson(
    {
      'id': 'id',
      'owner': 'owner',
      'title': 'title',
      'subtitle': 'subtitle',
      'thumbnail': 'thumbnail',
      'description': 'description',
    },
  );
  final Collection collection2 = Collection.fromJson(
    {
      'id': 'id',
      'owner': 'owner',
      'title': 'newTitle',
      'subtitle': 'subtitle',
      'thumbnail': 'thumbnail',
      'description': 'description',
    },
  );
  final List<Collection> collections = [collection];

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

  blocTest(
    'should call CollectionsFacade.deleteCollection on DeleteCollection event',
    build: () async {
      when(mockedProfileBloc.listen(any))
          .thenReturn(MockedStreamSubscription<ProfileState>());
      when(mockedFirebaseCollectionsFacade.getCollectionsForUser(username))
          .thenAnswer((_) async => Right(collections));
      when(mockedFirebaseCollectionsFacade.deleteCollection(any))
          .thenAnswer((_) async => Right(null));
      return CollectionsBloc(
        collectionsFacade: mockedFirebaseCollectionsFacade,
        profileBloc: mockedProfileBloc,
      );
    },
    act: (CollectionsBloc bloc) async => bloc
      ..add(GetCollectionsEvent(username: username))
      ..add(DeleteCollectionCollectionsEvent(collections[0])),
    verify: (_) async =>
        verify(mockedFirebaseCollectionsFacade.deleteCollection(collection))
            .called(1),
  );

  blocTest(
    'should yield Loaded state without deleted collection on DeleteCollection event',
    build: () async {
      when(mockedProfileBloc.listen(any))
          .thenReturn(MockedStreamSubscription<ProfileState>());
      when(mockedFirebaseCollectionsFacade.getCollectionsForUser(username))
          .thenAnswer((_) async => Right([collection]));
      when(mockedFirebaseCollectionsFacade.deleteCollection(any))
          .thenAnswer((_) async => Right(null));
      return CollectionsBloc(
        collectionsFacade: mockedFirebaseCollectionsFacade,
        profileBloc: mockedProfileBloc,
      );
    },
    act: (CollectionsBloc bloc) async => bloc
      ..add(GetCollectionsEvent(username: username))
      ..add(DeleteCollectionCollectionsEvent(collection)),
    expect: [
      LoadingCollectionsState(),
      LoadedCollectionsState(collections: []),
      LoadedCollectionsState(
        collections: [],
        toastMessage: Constants.collectionDeleted,
        toastType: ToastType.success,
      ),
    ],
  );

  blocTest(
    'should yield Loaded state with deleted collection on failed deletion',
    build: () async {
      when(mockedProfileBloc.listen(any))
          .thenReturn(MockedStreamSubscription<ProfileState>());
      when(mockedFirebaseCollectionsFacade.getCollectionsForUser(username))
          .thenAnswer((_) async => Right([collection]));
      when(mockedFirebaseCollectionsFacade.deleteCollection(any))
          .thenAnswer((_) async => Left(DataFailure()));
      return CollectionsBloc(
        collectionsFacade: mockedFirebaseCollectionsFacade,
        profileBloc: mockedProfileBloc,
      );
    },
    act: (CollectionsBloc bloc) async => bloc
      ..add(GetCollectionsEvent(username: username))
      ..add(DeleteCollectionCollectionsEvent(collection)),
    expect: [
      LoadingCollectionsState(),
      LoadedCollectionsState(collections: [collection]),
      LoadedCollectionsState(
        collections: [collection],
        toastMessage: Constants.collectionDeletionFailed,
        toastType: ToastType.error,
      ),
    ],
  );

  blocTest(
    'should yield EmptyCollectionsState on Reset',
    build: () async {
      when(mockedProfileBloc.listen(any))
          .thenReturn(MockedStreamSubscription<ProfileState>());
      return CollectionsBloc(
        collectionsFacade: mockedFirebaseCollectionsFacade,
        profileBloc: mockedProfileBloc,
      );
    },
    act: (CollectionsBloc bloc) async => bloc.add(ResetCollectionsEvent()),
    expect: [EmptyCollectionsState()],
  );

  blocTest(
    'should yield states with negated isSearching on ToggleSearch',
    build: () async {
      when(mockedProfileBloc.listen(any))
          .thenReturn(MockedStreamSubscription<ProfileState>());
      when(mockedFirebaseCollectionsFacade.getCollectionsForUser(username))
          .thenAnswer((_) async => Right([collection]));
      return CollectionsBloc(
        collectionsFacade: mockedFirebaseCollectionsFacade,
        profileBloc: mockedProfileBloc,
      );
    },
    act: (CollectionsBloc bloc) async => bloc
      ..add(GetCollectionsEvent(username: username))
      ..add(ToggleSearchCollectionsEvent())
      ..add(ToggleSearchCollectionsEvent()),
    expect: [
      LoadingCollectionsState(),
      LoadedCollectionsState(collections: [collection]),
      LoadedCollectionsState(collections: [collection], isSearching: true),
      LoadedCollectionsState(collections: [collection], isSearching: false),
    ],
  );

  blocTest(
    'should yield state with filtered collections on SearchQueryChanged',
    build: () async {
      when(mockedProfileBloc.listen(any))
          .thenReturn(MockedStreamSubscription<ProfileState>());
      when(mockedFirebaseCollectionsFacade.getCollectionsForUser(username))
          .thenAnswer((_) async => Right([collection, collection2]));
      return CollectionsBloc(
        collectionsFacade: mockedFirebaseCollectionsFacade,
        profileBloc: mockedProfileBloc,
      );
    },
    act: (CollectionsBloc bloc) async => bloc
      ..add(GetCollectionsEvent(username: username))
      ..add(SearchQueryChangedCollectionsEvent('new')),
    expect: [
      LoadingCollectionsState(),
      LoadedCollectionsState(collections: [collection2, collection]),
      LoadedCollectionsState(
        collections: [collection2, collection],
        displayedCollections: [collection2],
        isSearching: true,
      ),
    ],
  );
}
