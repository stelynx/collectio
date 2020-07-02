import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:collectio/app/bloc/collections/collection_items_bloc.dart';
import 'package:collectio/app/bloc/collections/new_item_bloc.dart';
import 'package:collectio/facade/collections/collections_facade.dart';
import 'package:collectio/facade/maps/maps_facade.dart';
import 'package:collectio/model/collection.dart';
import 'package:collectio/model/collection_item.dart';
import 'package:collectio/model/value_object/description.dart' as model;
import 'package:collectio/model/value_object/photo.dart';
import 'package:collectio/model/value_object/subtitle.dart';
import 'package:collectio/model/value_object/title.dart';
import 'package:collectio/util/error/data_failure.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.dart';

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

  File mockedFile = MockedFile();

  MapsFacade mockedMapsFacade;
  CollectionsFacade mockedCollectionsFacade;
  CollectionItemsBloc mockedCollectionItemsBloc;

  setUp(() {
    mockedMapsFacade = getIt<MapsFacade>();
    mockedCollectionsFacade = getIt<CollectionsFacade>();
    mockedCollectionItemsBloc = getIt<CollectionItemsBloc>();
  });

  tearDown(() {
    mockedCollectionItemsBloc.close();
  });

  blocTest(
    'should set owner and collection name on initialization event',
    build: () async => NewItemBloc(
        mapsFacade: mockedMapsFacade,
        collectionItemsBloc: mockedCollectionItemsBloc,
        collectionsFacade: mockedCollectionsFacade),
    act: (NewItemBloc bloc) async =>
        bloc.add(InitializeNewItemEvent(collection)),
    expect: [
      GeneralNewItemState(collection: collection),
    ],
  );

  blocTest(
    'should set title on title changed event',
    build: () async => NewItemBloc(
        mapsFacade: mockedMapsFacade,
        collectionItemsBloc: mockedCollectionItemsBloc,
        collectionsFacade: mockedCollectionsFacade),
    act: (NewItemBloc bloc) async =>
        bloc.add(TitleChangedNewItemEvent('title')),
    expect: [
      GeneralNewItemState(title: Title('title')),
    ],
  );

  blocTest(
    'should set subtitle on subtitle changed event',
    build: () async => NewItemBloc(
        mapsFacade: mockedMapsFacade,
        collectionItemsBloc: mockedCollectionItemsBloc,
        collectionsFacade: mockedCollectionsFacade),
    act: (NewItemBloc bloc) async =>
        bloc.add(SubtitleChangedNewItemEvent('subtitle')),
    expect: [
      GeneralNewItemState(subtitle: Subtitle('subtitle')),
    ],
  );

  blocTest(
    'should set description on description changed event',
    build: () async => NewItemBloc(
        mapsFacade: mockedMapsFacade,
        collectionItemsBloc: mockedCollectionItemsBloc,
        collectionsFacade: mockedCollectionsFacade),
    act: (NewItemBloc bloc) async =>
        bloc.add(DescriptionChangedNewItemEvent('description')),
    expect: [
      GeneralNewItemState(description: model.Description('description')),
    ],
  );

  blocTest(
    'should set raiting on raiting changed event',
    build: () async => NewItemBloc(
        mapsFacade: mockedMapsFacade,
        collectionItemsBloc: mockedCollectionItemsBloc,
        collectionsFacade: mockedCollectionsFacade),
    act: (NewItemBloc bloc) async => bloc.add(RaitingChangedNewItemEvent(6)),
    expect: [
      GeneralNewItemState(raiting: 6),
    ],
  );

  blocTest(
    'should set local image on image changed event',
    build: () async => NewItemBloc(
        mapsFacade: mockedMapsFacade,
        collectionItemsBloc: mockedCollectionItemsBloc,
        collectionsFacade: mockedCollectionsFacade),
    act: (NewItemBloc bloc) async =>
        bloc.add(ImageChangedNewItemEvent(image: mockedFile, metadata: null)),
    expect: [
      GeneralNewItemState(localImage: Photo(mockedFile)),
    ],
  );

  blocTest(
    'should start showing error messages on submit if collection is null',
    build: () async => NewItemBloc(
        mapsFacade: mockedMapsFacade,
        collectionItemsBloc: mockedCollectionItemsBloc,
        collectionsFacade: mockedCollectionsFacade),
    act: (NewItemBloc bloc) async => bloc
      ..add(InitializeNewItemEvent(null))
      ..add(TitleChangedNewItemEvent('title'))
      ..add(SubtitleChangedNewItemEvent('subtitle'))
      ..add(DescriptionChangedNewItemEvent('description'))
      ..add(RaitingChangedNewItemEvent(5))
      ..add(ImageChangedNewItemEvent(image: mockedFile, metadata: null))
      ..add(SubmitNewItemEvent()),
    expect: [
      GeneralNewItemState(collection: null),
      GeneralNewItemState(
        collection: null,
        title: Title('title'),
      ),
      GeneralNewItemState(
        collection: null,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
      ),
      GeneralNewItemState(
        collection: null,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
      ),
      GeneralNewItemState(
        collection: null,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
        raiting: 5,
      ),
      GeneralNewItemState(
        collection: null,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
        raiting: 5,
        localImage: Photo(mockedFile),
      ),
      GeneralNewItemState(
        collection: null,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
        raiting: 5,
        localImage: Photo(mockedFile),
        showErrorMessages: true,
      ),
    ],
  );

  blocTest(
    'should start showing error messages on submit if bad title',
    build: () async => NewItemBloc(
        mapsFacade: mockedMapsFacade,
        collectionItemsBloc: mockedCollectionItemsBloc,
        collectionsFacade: mockedCollectionsFacade),
    act: (NewItemBloc bloc) async => bloc
      ..add(InitializeNewItemEvent(collection))
      ..add(SubtitleChangedNewItemEvent('subtitle'))
      ..add(DescriptionChangedNewItemEvent('description'))
      ..add(RaitingChangedNewItemEvent(5))
      ..add(ImageChangedNewItemEvent(image: mockedFile, metadata: null))
      ..add(SubmitNewItemEvent()),
    expect: [
      GeneralNewItemState(collection: collection),
      GeneralNewItemState(
        collection: collection,
        subtitle: Subtitle('subtitle'),
      ),
      GeneralNewItemState(
        collection: collection,
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
      ),
      GeneralNewItemState(
        collection: collection,
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
        raiting: 5,
      ),
      GeneralNewItemState(
        collection: collection,
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
        raiting: 5,
        localImage: Photo(mockedFile),
      ),
      GeneralNewItemState(
        collection: collection,
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
        raiting: 5,
        localImage: Photo(mockedFile),
        showErrorMessages: true,
      ),
    ],
  );

  blocTest(
    'should start showing error messages on submit if bad subtitle',
    build: () async => NewItemBloc(
        mapsFacade: mockedMapsFacade,
        collectionItemsBloc: mockedCollectionItemsBloc,
        collectionsFacade: mockedCollectionsFacade),
    act: (NewItemBloc bloc) async => bloc
      ..add(InitializeNewItemEvent(collection))
      ..add(TitleChangedNewItemEvent('title'))
      ..add(DescriptionChangedNewItemEvent('description'))
      ..add(RaitingChangedNewItemEvent(5))
      ..add(ImageChangedNewItemEvent(image: mockedFile, metadata: null))
      ..add(SubmitNewItemEvent()),
    expect: [
      GeneralNewItemState(
        collection: collection,
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        description: model.Description('description'),
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        description: model.Description('description'),
        raiting: 5,
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        description: model.Description('description'),
        raiting: 5,
        localImage: Photo(mockedFile),
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        description: model.Description('description'),
        raiting: 5,
        localImage: Photo(mockedFile),
        showErrorMessages: true,
      ),
    ],
  );

  blocTest(
    'should start showing error messages on submit if bad description',
    build: () async => NewItemBloc(
        mapsFacade: mockedMapsFacade,
        collectionItemsBloc: mockedCollectionItemsBloc,
        collectionsFacade: mockedCollectionsFacade),
    act: (NewItemBloc bloc) async => bloc
      ..add(InitializeNewItemEvent(collection))
      ..add(TitleChangedNewItemEvent('title'))
      ..add(SubtitleChangedNewItemEvent('subtitle'))
      ..add(RaitingChangedNewItemEvent(5))
      ..add(ImageChangedNewItemEvent(image: mockedFile, metadata: null))
      ..add(SubmitNewItemEvent()),
    expect: [
      GeneralNewItemState(
        collection: collection,
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
        raiting: 5,
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
        raiting: 5,
        localImage: Photo(mockedFile),
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
        raiting: 5,
        localImage: Photo(mockedFile),
        showErrorMessages: true,
      ),
    ],
  );

  blocTest(
    'should start showing error messages on submit if bad raiting',
    build: () async => NewItemBloc(
        mapsFacade: mockedMapsFacade,
        collectionItemsBloc: mockedCollectionItemsBloc,
        collectionsFacade: mockedCollectionsFacade),
    act: (NewItemBloc bloc) async => bloc
      ..add(InitializeNewItemEvent(collection))
      ..add(TitleChangedNewItemEvent('title'))
      ..add(SubtitleChangedNewItemEvent('subtitle'))
      ..add(DescriptionChangedNewItemEvent('description'))
      ..add(ImageChangedNewItemEvent(image: mockedFile, metadata: null))
      ..add(SubmitNewItemEvent()),
    expect: [
      GeneralNewItemState(
        collection: collection,
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
        localImage: Photo(mockedFile),
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
        localImage: Photo(mockedFile),
        showErrorMessages: true,
      ),
    ],
  );

  blocTest(
    'should start showing error messages on submit if no image',
    build: () async => NewItemBloc(
        mapsFacade: mockedMapsFacade,
        collectionItemsBloc: mockedCollectionItemsBloc,
        collectionsFacade: mockedCollectionsFacade),
    act: (NewItemBloc bloc) async => bloc
      ..add(InitializeNewItemEvent(collection))
      ..add(TitleChangedNewItemEvent('title'))
      ..add(SubtitleChangedNewItemEvent('subtitle'))
      ..add(DescriptionChangedNewItemEvent('description'))
      ..add(RaitingChangedNewItemEvent(6))
      ..add(SubmitNewItemEvent()),
    expect: [
      GeneralNewItemState(
        collection: collection,
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
        raiting: 6,
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
        raiting: 6,
        showErrorMessages: true,
      ),
    ],
  );

  blocTest(
    'should call CollectionsFacade if all fields are valid',
    build: () async {
      when(mockedFile.path).thenReturn('image.jpg');
      when(mockedCollectionsFacade.uploadCollectionItemImage(
              image: anyNamed('image'),
              destinationName: anyNamed('destinationName')))
          .thenAnswer((_) async => Right(null));
      return NewItemBloc(
          mapsFacade: mockedMapsFacade,
          collectionItemsBloc: mockedCollectionItemsBloc,
          collectionsFacade: mockedCollectionsFacade);
    },
    act: (NewItemBloc bloc) async => bloc
      ..add(InitializeNewItemEvent(collection))
      ..add(TitleChangedNewItemEvent('title'))
      ..add(SubtitleChangedNewItemEvent('subtitle'))
      ..add(DescriptionChangedNewItemEvent('description'))
      ..add(RaitingChangedNewItemEvent(5))
      ..add(ImageChangedNewItemEvent(image: mockedFile, metadata: null))
      ..add(SubmitNewItemEvent()),
    verify: (_) async => verify(mockedCollectionsFacade.addItemToCollection(
        owner: 'owner',
        collectionName: 'title',
        item: CollectionItem(
          added: null, // added is not in the props
          title: 'title',
          subtitle: 'subtitle',
          description: 'description',
          imageUrl: null, // imageUrl is not in the props
          raiting: 5,
          imageMetadata: null,
        ))).called(1),
  );

  blocTest(
    'should add GetCollectionItemsEvent to CollectionItemsBloc if adding item and image successful',
    build: () async {
      when(mockedFile.path).thenReturn('path.jpg');
      when(mockedCollectionsFacade.addItemToCollection(
              owner: anyNamed('owner'),
              collectionName: anyNamed('collectionName'),
              item: anyNamed('item')))
          .thenAnswer((_) async => Right(null));
      when(mockedCollectionsFacade.uploadCollectionItemImage(
              image: anyNamed('image'),
              destinationName: anyNamed('destinationName')))
          .thenAnswer((_) async => Right(null));
      return NewItemBloc(
          mapsFacade: mockedMapsFacade,
          collectionItemsBloc: mockedCollectionItemsBloc,
          collectionsFacade: mockedCollectionsFacade);
    },
    act: (NewItemBloc bloc) async => bloc
      ..add(InitializeNewItemEvent(collection))
      ..add(TitleChangedNewItemEvent('title'))
      ..add(SubtitleChangedNewItemEvent('subtitle'))
      ..add(DescriptionChangedNewItemEvent('description'))
      ..add(RaitingChangedNewItemEvent(5))
      ..add(ImageChangedNewItemEvent(image: mockedFile, metadata: null))
      ..add(SubmitNewItemEvent()),
    verify: (_) async => verify(mockedCollectionItemsBloc.add(
      GetCollectionItemsEvent(collection),
    )).called(1),
  );

  blocTest(
    'should yield two states on submit if all fields are valid and adding successful',
    build: () async {
      when(mockedFile.path).thenReturn('path.jpg');
      when(mockedCollectionsFacade.uploadCollectionItemImage(
              image: anyNamed('image'),
              destinationName: anyNamed('destinationName')))
          .thenAnswer((_) async => Right(null));
      when(mockedCollectionsFacade.addItemToCollection(
              owner: anyNamed('owner'),
              collectionName: anyNamed('collectionName'),
              item: anyNamed('item')))
          .thenAnswer((_) async => Right(null));
      return NewItemBloc(
          mapsFacade: mockedMapsFacade,
          collectionItemsBloc: mockedCollectionItemsBloc,
          collectionsFacade: mockedCollectionsFacade);
    },
    act: (NewItemBloc bloc) async => bloc
      ..add(InitializeNewItemEvent(collection))
      ..add(TitleChangedNewItemEvent('title'))
      ..add(SubtitleChangedNewItemEvent('subtitle'))
      ..add(DescriptionChangedNewItemEvent('description'))
      ..add(RaitingChangedNewItemEvent(5))
      ..add(ImageChangedNewItemEvent(image: mockedFile, metadata: null))
      ..add(SubmitNewItemEvent()),
    expect: [
      GeneralNewItemState(collection: collection),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
        raiting: 5,
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
        raiting: 5,
        localImage: Photo(mockedFile),
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
        raiting: 5,
        localImage: Photo(mockedFile),
        isSubmitting: true,
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
        raiting: 5,
        localImage: Photo(mockedFile),
        isSubmitting: false,
        showErrorMessages: true,
        dataFailure: Right(null),
      ),
    ],
  );

  blocTest(
    'should yield two states on submit if all fields are valid and adding unsuccessful',
    build: () async {
      when(mockedFile.path).thenReturn('path.jpg');
      when(mockedCollectionsFacade.uploadCollectionItemImage(
              image: anyNamed('image'),
              destinationName: anyNamed('destinationName')))
          .thenAnswer((_) async => Right(null));
      when(mockedCollectionsFacade.addItemToCollection(
              owner: anyNamed('owner'),
              collectionName: anyNamed('collectionName'),
              item: anyNamed('item')))
          .thenAnswer((_) async => Left(DataFailure()));
      return NewItemBloc(
          mapsFacade: mockedMapsFacade,
          collectionItemsBloc: mockedCollectionItemsBloc,
          collectionsFacade: mockedCollectionsFacade);
    },
    act: (NewItemBloc bloc) async => bloc
      ..add(InitializeNewItemEvent(collection))
      ..add(TitleChangedNewItemEvent('title'))
      ..add(SubtitleChangedNewItemEvent('subtitle'))
      ..add(DescriptionChangedNewItemEvent('description'))
      ..add(RaitingChangedNewItemEvent(5))
      ..add(ImageChangedNewItemEvent(image: mockedFile, metadata: null))
      ..add(SubmitNewItemEvent()),
    expect: [
      GeneralNewItemState(
        collection: collection,
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
        raiting: 5,
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
        raiting: 5,
        localImage: Photo(mockedFile),
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
        raiting: 5,
        localImage: Photo(mockedFile),
        isSubmitting: true,
      ),
      GeneralNewItemState(
        collection: collection,
        title: Title('title'),
        subtitle: Subtitle('subtitle'),
        description: model.Description('description'),
        raiting: 5,
        localImage: Photo(mockedFile),
        isSubmitting: false,
        showErrorMessages: true,
        dataFailure: Left(DataFailure()),
      ),
    ],
  );
}
