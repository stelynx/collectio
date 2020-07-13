import 'package:bloc_test/bloc_test.dart';
import 'package:collectio/app/bloc/collections/collection_items_bloc.dart';
import 'package:collectio/app/widgets/collectio_toast.dart';
import 'package:collectio/facade/collections/collections_facade.dart';
import 'package:collectio/facade/collections/firebase/firebase_collections_facade.dart';
import 'package:collectio/model/collection.dart';
import 'package:collectio/model/collection_item.dart';
import 'package:collectio/util/constant/translation.dart';
import 'package:collectio/util/error/data_failure.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

void main() {
  configureInjection(Environment.test);

  final Collection collection = Collection(
    id: 'title',
    owner: 'owner',
    title: 'title',
    subtitle: 'subtitle',
    description: 'description',
    thumbnail: 'thumbnail',
  );

  final CollectionItem collectionItem1 = CollectionItem(
    parent: collection,
    id: 'id',
    added: DateTime.fromMillisecondsSinceEpoch(10000),
    title: 'title',
    subtitle: 'subtitle',
    description: 'description',
    imageUrl: 'imageUrl',
    rating: 10,
    imageMetadata: null,
  );
  final CollectionItem collectionItem2 = CollectionItem(
    parent: collection,
    id: 'id',
    added: DateTime.fromMillisecondsSinceEpoch(10000),
    title: 'a different title',
    subtitle: 'subtitle',
    description: 'description',
    imageUrl: 'imageUrl',
    rating: 10,
    imageMetadata: null,
  );

  final List<CollectionItem> collectionItems = [collectionItem1];

  final MockedFirebaseCollectionsFacade mockedFirebaseCollectionsFacade =
      getIt<CollectionsFacade>();

  blocTest(
    'should yield Loading and Loaded on successful GetCollectionItemsEvent',
    build: () async {
      when(mockedFirebaseCollectionsFacade.getItemsInCollection(any))
          .thenAnswer((_) async => Right(collectionItems));
      return CollectionItemsBloc(
          collectionsFacade: mockedFirebaseCollectionsFacade);
    },
    act: (CollectionItemsBloc bloc) async =>
        bloc.add(GetCollectionItemsEvent(collection)),
    expect: [
      LoadingCollectionItemsState(),
      LoadedCollectionItemsState(collectionItems: collectionItems)
    ],
  );

  blocTest(
    'should yield Error on unsuccessful GetCollectionItemsEvent',
    build: () async {
      when(mockedFirebaseCollectionsFacade.getItemsInCollection(any))
          .thenAnswer((_) async => Left(DataFailure()));
      return CollectionItemsBloc(
          collectionsFacade: mockedFirebaseCollectionsFacade);
    },
    act: (CollectionItemsBloc bloc) async =>
        bloc.add(GetCollectionItemsEvent(collection)),
    expect: [LoadingCollectionItemsState(), ErrorCollectionItemsState()],
  );

  blocTest(
    'should call CollectionsFacade.deleteCollection on DeleteCollection event',
    build: () async {
      when(mockedFirebaseCollectionsFacade.getItemsInCollection(any))
          .thenAnswer((_) async => Right([collectionItems[0]]));
      when(mockedFirebaseCollectionsFacade.deleteItemInCollection(
              collectionItem: anyNamed('collectionItem')))
          .thenAnswer((_) async => Right(null));
      return CollectionItemsBloc(
          collectionsFacade: mockedFirebaseCollectionsFacade);
    },
    act: (CollectionItemsBloc bloc) async => bloc
      ..add(GetCollectionItemsEvent(collection))
      ..add(DeleteItemCollectionItemsEvent(collectionItems[0])),
    verify: (_) async => verify(mockedFirebaseCollectionsFacade
            .deleteItemInCollection(collectionItem: collectionItems[0]))
        .called(1),
  );

  blocTest(
    'should yield Loaded state without deleted collection on DeleteCollection event',
    build: () async {
      when(mockedFirebaseCollectionsFacade.getItemsInCollection(any))
          .thenAnswer((_) async => Right([collectionItems[0]]));
      when(mockedFirebaseCollectionsFacade.deleteItemInCollection(
              collectionItem: anyNamed('collectionItem')))
          .thenAnswer((_) async => Right(null));
      return CollectionItemsBloc(
          collectionsFacade: mockedFirebaseCollectionsFacade);
    },
    act: (CollectionItemsBloc bloc) async => bloc
      ..add(GetCollectionItemsEvent(collection))
      ..add(DeleteItemCollectionItemsEvent(collectionItems[0])),
    expect: [
      LoadingCollectionItemsState(),
      LoadedCollectionItemsState(collectionItems: []),
      LoadedCollectionItemsState(
        collectionItems: [],
        toastMessage: Translation.collectionItemDeleted,
        toastType: ToastType.success,
      ),
    ],
  );

  blocTest(
    'should yield Loaded state with deleted collection on failed deletion',
    build: () async {
      when(mockedFirebaseCollectionsFacade.getItemsInCollection(any))
          .thenAnswer((_) async => Right([collectionItems[0]]));
      when(mockedFirebaseCollectionsFacade.deleteItemInCollection(
              collectionItem: anyNamed('collectionItem')))
          .thenAnswer((_) async => Left(DataFailure()));
      return CollectionItemsBloc(
          collectionsFacade: mockedFirebaseCollectionsFacade);
    },
    act: (CollectionItemsBloc bloc) async => bloc
      ..add(GetCollectionItemsEvent(collection))
      ..add(DeleteItemCollectionItemsEvent(collectionItems[0])),
    expect: [
      LoadingCollectionItemsState(),
      LoadedCollectionItemsState(collectionItems: collectionItems),
      LoadedCollectionItemsState(
        collectionItems: collectionItems,
        toastMessage: Translation.collectionItemDeletionFailed,
        toastType: ToastType.error,
      ),
    ],
  );

  blocTest(
    'should toggle isSearching when ToggleSearch',
    build: () async {
      when(mockedFirebaseCollectionsFacade.getItemsInCollection(any))
          .thenAnswer((_) async => Right(collectionItems));
      return CollectionItemsBloc(
          collectionsFacade: mockedFirebaseCollectionsFacade);
    },
    act: (CollectionItemsBloc bloc) async => bloc
      ..add(GetCollectionItemsEvent(collection))
      ..add(ToggleSearchCollectionItemsEvent())
      ..add(ToggleSearchCollectionItemsEvent()),
    expect: [
      LoadingCollectionItemsState(),
      LoadedCollectionItemsState(collectionItems: collectionItems),
      LoadedCollectionItemsState(
        collectionItems: collectionItems,
        isSearching: true,
      ),
      LoadedCollectionItemsState(
        collectionItems: collectionItems,
        isSearching: false,
      ),
    ],
  );

  blocTest(
    'should yield filtered items when searching',
    build: () async {
      when(mockedFirebaseCollectionsFacade.getItemsInCollection(any))
          .thenAnswer((_) async => Right([collectionItem1, collectionItem2]));
      return CollectionItemsBloc(
          collectionsFacade: mockedFirebaseCollectionsFacade);
    },
    act: (CollectionItemsBloc bloc) async => bloc
      ..add(GetCollectionItemsEvent(collection))
      ..add(SearchQueryChangedCollectionItemsEvent('a diff')),
    expect: [
      LoadingCollectionItemsState(),
      LoadedCollectionItemsState(
          collectionItems: [collectionItem1, collectionItem2]),
      LoadedCollectionItemsState(
          collectionItems: [collectionItem1, collectionItem2],
          displayedCollectionItems: [collectionItem2],
          isSearching: true),
    ],
  );
}
