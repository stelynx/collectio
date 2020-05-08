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
}
