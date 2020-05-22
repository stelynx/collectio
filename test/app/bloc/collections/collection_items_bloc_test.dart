import 'package:bloc_test/bloc_test.dart';
import 'package:collectio/app/bloc/collections/collection_items_bloc.dart';
import 'package:collectio/facade/collections/collections_facade.dart';
import 'package:collectio/facade/collections/firebase/firebase_collections_facade.dart';
import 'package:collectio/model/collection_item.dart';
import 'package:collectio/util/error/data_failure.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

void main() {
  configureInjection(Environment.test);

  final List<CollectionItem> collectionItems = [
    CollectionItem(
      owner: 'owner',
      collectionId: 'collectionName',
      id: 'id',
      added: DateTime.fromMillisecondsSinceEpoch(10000),
      title: 'title',
      subtitle: 'subtitle',
      description: 'description',
      imageUrl: 'imageUrl',
      raiting: 10,
    ),
  ];

  final MockedFirebaseCollectionsFacade mockedFirebaseCollectionsFacade =
      getIt<CollectionsFacade>();

  blocTest(
    'should yield Loading and Loaded on successful GetCollectionItemsEvent',
    build: () async {
      when(mockedFirebaseCollectionsFacade.getItemsInCollection(any, any))
          .thenAnswer((_) async => Right(collectionItems));
      return CollectionItemsBloc(
          collectionsFacade: mockedFirebaseCollectionsFacade);
    },
    act: (CollectionItemsBloc bloc) async => bloc.add(GetCollectionItemsEvent(
        collectionOwner: 'owner', collectionName: 'name')),
    expect: [
      LoadingCollectionItemsState(),
      LoadedCollectionItemsState(collectionItems)
    ],
  );

  blocTest(
    'should yield Error on unsuccessful GetCollectionItemsEvent',
    build: () async {
      when(mockedFirebaseCollectionsFacade.getItemsInCollection(any, any))
          .thenAnswer((_) async => Left(DataFailure()));
      return CollectionItemsBloc(
          collectionsFacade: mockedFirebaseCollectionsFacade);
    },
    act: (CollectionItemsBloc bloc) async => bloc.add(GetCollectionItemsEvent(
        collectionOwner: 'owner', collectionName: 'name')),
    expect: [LoadingCollectionItemsState(), ErrorCollectionItemsState()],
  );

  blocTest(
    'should call CollectionsFacade.deleteCollection on DeleteCollection event',
    build: () async {
      when(mockedFirebaseCollectionsFacade.getItemsInCollection(any, any))
          .thenAnswer((_) async => Right([collectionItems[0]]));
      when(mockedFirebaseCollectionsFacade.deleteItemInCollection(
              collectionItem: anyNamed('collectionItem')))
          .thenAnswer((_) async => Right(null));
      return CollectionItemsBloc(
          collectionsFacade: mockedFirebaseCollectionsFacade);
    },
    act: (CollectionItemsBloc bloc) async => bloc
      ..add(GetCollectionItemsEvent(
          collectionName: 'collectionName', collectionOwner: 'owner'))
      ..add(DeleteItemCollectionItemsEvent(collectionItems[0])),
    verify: (_) async => verify(mockedFirebaseCollectionsFacade
            .deleteItemInCollection(collectionItem: collectionItems[0]))
        .called(1),
  );

  blocTest(
    'should yield Loaded state without deleted collection on DeleteCollection event',
    build: () async {
      when(mockedFirebaseCollectionsFacade.getItemsInCollection(any, any))
          .thenAnswer((_) async => Right([collectionItems[0]]));
      when(mockedFirebaseCollectionsFacade.deleteItemInCollection(
              collectionItem: anyNamed('collectionItem')))
          .thenAnswer((_) async => Right(null));
      return CollectionItemsBloc(
          collectionsFacade: mockedFirebaseCollectionsFacade);
    },
    act: (CollectionItemsBloc bloc) async => bloc
      ..add(GetCollectionItemsEvent(
          collectionName: 'collectionName', collectionOwner: 'owner'))
      ..add(DeleteItemCollectionItemsEvent(collectionItems[0])),
    expect: [
      LoadingCollectionItemsState(),
      LoadedCollectionItemsState([]),
    ],
  );

  blocTest(
    'should yield Loaded state with deleted collection on failed deletion',
    build: () async {
      when(mockedFirebaseCollectionsFacade.getItemsInCollection(any, any))
          .thenAnswer((_) async => Right([collectionItems[0]]));
      when(mockedFirebaseCollectionsFacade.deleteItemInCollection(
              collectionItem: anyNamed('collectionItem')))
          .thenAnswer((_) async => Left(DataFailure()));
      return CollectionItemsBloc(
          collectionsFacade: mockedFirebaseCollectionsFacade);
    },
    act: (CollectionItemsBloc bloc) async => bloc
      ..add(GetCollectionItemsEvent(
          collectionName: 'collectionName', collectionOwner: 'owner'))
      ..add(DeleteItemCollectionItemsEvent(collectionItems[0])),
    expect: [
      LoadingCollectionItemsState(),
      LoadedCollectionItemsState(collectionItems),
    ],
  );
}
