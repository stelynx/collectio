import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:collectio/app/bloc/collections/collections_bloc.dart';
import 'package:collectio/app/bloc/collections/new_collection_bloc.dart';
import 'package:collectio/app/bloc/in_app_purchase/in_app_purchase_bloc.dart';
import 'package:collectio/app/bloc/profile/profile_bloc.dart';
import 'package:collectio/facade/collections/collections_facade.dart';
import 'package:collectio/model/collection.dart';
import 'package:collectio/model/user_profile.dart';
import 'package:collectio/model/value_object/description.dart' as model;
import 'package:collectio/model/value_object/name.dart';
import 'package:collectio/model/value_object/photo.dart';
import 'package:collectio/model/value_object/subtitle.dart';
import 'package:collectio/model/value_object/title.dart';
import 'package:collectio/util/constant/translation.dart';
import 'package:collectio/util/error/data_failure.dart';
import 'package:collectio/util/function/image_name_generator.dart';
import 'package:collectio/util/injection/injection.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:injectable/injectable.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.dart';

void main() {
  configureInjection(Environment.test);

  final File mockedFile = MockedFile();

  CollectionsFacade mockedCollectionsFacade;
  ProfileBloc mockedProfileBloc;
  CollectionsBloc mockedCollectionsBloc;
  InAppPurchaseBloc mockedInAppPurchaseBloc;

  setUp(() {
    mockedCollectionsFacade = getIt<CollectionsFacade>();
    mockedProfileBloc = getIt<ProfileBloc>();
    mockedCollectionsBloc = getIt<CollectionsBloc>();
    mockedInAppPurchaseBloc = getIt<InAppPurchaseBloc>();
  });

  tearDown(() {
    mockedProfileBloc.close();
    mockedCollectionsBloc.close();
    mockedInAppPurchaseBloc.close();
  });

  blocTest(
    'should change title on TitleChanged',
    build: () async {
      when(mockedInAppPurchaseBloc.listen(any))
          .thenReturn(MockedStreamSubscription());
      return NewCollectionBloc(
        collectionsFacade: mockedCollectionsFacade,
        profileBloc: mockedProfileBloc,
        collectionsBloc: mockedCollectionsBloc,
        inAppPurchaseBloc: mockedInAppPurchaseBloc,
      );
    },
    act: (NewCollectionBloc bloc) async =>
        bloc.add(TitleChangedNewCollectionEvent('t')),
    expect: [
      GeneralNewCollectionState(title: Title('t')),
    ],
  );

  blocTest(
    'should change subtitle on SubtitleChanged',
    build: () async {
      when(mockedInAppPurchaseBloc.listen(any))
          .thenReturn(MockedStreamSubscription());
      return NewCollectionBloc(
        collectionsFacade: mockedCollectionsFacade,
        profileBloc: mockedProfileBloc,
        collectionsBloc: mockedCollectionsBloc,
        inAppPurchaseBloc: mockedInAppPurchaseBloc,
      );
    },
    act: (NewCollectionBloc bloc) async =>
        bloc.add(SubtitleChangedNewCollectionEvent('t')),
    expect: [
      GeneralNewCollectionState(subtitle: Subtitle('t')),
    ],
  );

  blocTest(
    'should change description on DescriptionChanged',
    build: () async {
      when(mockedInAppPurchaseBloc.listen(any))
          .thenReturn(MockedStreamSubscription());
      return NewCollectionBloc(
        collectionsFacade: mockedCollectionsFacade,
        profileBloc: mockedProfileBloc,
        collectionsBloc: mockedCollectionsBloc,
        inAppPurchaseBloc: mockedInAppPurchaseBloc,
      );
    },
    act: (NewCollectionBloc bloc) async =>
        bloc.add(DescriptionChangedNewCollectionEvent('t')),
    expect: [
      GeneralNewCollectionState(description: model.Description('t')),
    ],
  );

  blocTest(
    'should change image on ImageChanged',
    build: () async {
      when(mockedInAppPurchaseBloc.listen(any))
          .thenReturn(MockedStreamSubscription());
      return NewCollectionBloc(
        collectionsFacade: mockedCollectionsFacade,
        profileBloc: mockedProfileBloc,
        collectionsBloc: mockedCollectionsBloc,
        inAppPurchaseBloc: mockedInAppPurchaseBloc,
      );
    },
    act: (NewCollectionBloc bloc) async =>
        bloc.add(ImageChangedNewCollectionEvent(mockedFile)),
    expect: [
      GeneralNewCollectionState(thumbnail: Photo(mockedFile)),
    ],
  );

  blocTest(
    'should change image on ItemTitleNameChanged',
    build: () async {
      when(mockedInAppPurchaseBloc.listen(any))
          .thenReturn(MockedStreamSubscription());
      return NewCollectionBloc(
        collectionsFacade: mockedCollectionsFacade,
        profileBloc: mockedProfileBloc,
        collectionsBloc: mockedCollectionsBloc,
        inAppPurchaseBloc: mockedInAppPurchaseBloc,
      );
    },
    act: (NewCollectionBloc bloc) async =>
        bloc.add(ItemTitleNameChangedNewCollectionEvent('Title123')),
    expect: [
      GeneralNewCollectionState(itemTitleName: Name('Title123')),
    ],
  );

  blocTest(
    'should change image on ItemSubtitleNameChanged',
    build: () async {
      when(mockedInAppPurchaseBloc.listen(any))
          .thenReturn(MockedStreamSubscription());
      return NewCollectionBloc(
        collectionsFacade: mockedCollectionsFacade,
        profileBloc: mockedProfileBloc,
        collectionsBloc: mockedCollectionsBloc,
        inAppPurchaseBloc: mockedInAppPurchaseBloc,
      );
    },
    act: (NewCollectionBloc bloc) async =>
        bloc.add(ItemSubtitleNameChangedNewCollectionEvent('Subtitle123')),
    expect: [
      GeneralNewCollectionState(itemSubtitleName: Name('Subtitle123')),
    ],
  );

  blocTest(
    'should change image on ItemDescriptionNameChanged',
    build: () async {
      when(mockedInAppPurchaseBloc.listen(any))
          .thenReturn(MockedStreamSubscription());
      return NewCollectionBloc(
        collectionsFacade: mockedCollectionsFacade,
        profileBloc: mockedProfileBloc,
        collectionsBloc: mockedCollectionsBloc,
        inAppPurchaseBloc: mockedInAppPurchaseBloc,
      );
    },
    act: (NewCollectionBloc bloc) async => bloc
        .add(ItemDescriptionNameChangedNewCollectionEvent('Description123')),
    expect: [
      GeneralNewCollectionState(itemDescriptionName: Name('Description123')),
    ],
  );

  group('SubmitNewCollectionEvent', () {
    blocTest(
      'should do nothing if ProfileBloc.state is not Complete',
      build: () async {
        when(mockedInAppPurchaseBloc.listen(any))
            .thenReturn(MockedStreamSubscription());
        when(mockedProfileBloc.state).thenReturn(InitialProfileState());
        when(mockedCollectionsBloc.state)
            .thenReturn(LoadedCollectionsState(collections: []));
        return NewCollectionBloc(
          collectionsFacade: mockedCollectionsFacade,
          profileBloc: mockedProfileBloc,
          collectionsBloc: mockedCollectionsBloc,
          inAppPurchaseBloc: mockedInAppPurchaseBloc,
        );
      },
      act: (NewCollectionBloc bloc) async => bloc
        ..add(TitleChangedNewCollectionEvent('title'))
        ..add(SubtitleChangedNewCollectionEvent('subtitle'))
        ..add(DescriptionChangedNewCollectionEvent('description'))
        ..add(SubmitNewCollectionEvent()),
      expect: [
        GeneralNewCollectionState(title: Title('title')),
        GeneralNewCollectionState(
            title: Title('title'), subtitle: Subtitle('subtitle')),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description')),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description'),
            isSubmitting: true),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description'),
            isSubmitting: false,
            showErrorMessages: true),
      ],
    );

    blocTest(
      'should do nothing if CollectionsBloc.state is not Loaded',
      build: () async {
        when(mockedInAppPurchaseBloc.listen(any))
            .thenReturn(MockedStreamSubscription());
        when(mockedProfileBloc.state).thenReturn(CompleteProfileState(null));
        when(mockedCollectionsBloc.state).thenReturn(InitialCollectionsState());
        return NewCollectionBloc(
          collectionsFacade: mockedCollectionsFacade,
          profileBloc: mockedProfileBloc,
          collectionsBloc: mockedCollectionsBloc,
          inAppPurchaseBloc: mockedInAppPurchaseBloc,
        );
      },
      act: (NewCollectionBloc bloc) async => bloc
        ..add(TitleChangedNewCollectionEvent('title'))
        ..add(SubtitleChangedNewCollectionEvent('subtitle'))
        ..add(DescriptionChangedNewCollectionEvent('description'))
        ..add(SubmitNewCollectionEvent()),
      expect: [
        GeneralNewCollectionState(title: Title('title')),
        GeneralNewCollectionState(
            title: Title('title'), subtitle: Subtitle('subtitle')),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description')),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description'),
            isSubmitting: true),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description'),
            isSubmitting: false,
            showErrorMessages: true),
      ],
    );

    blocTest(
      'should do nothing if title is not valid',
      build: () async {
        when(mockedInAppPurchaseBloc.listen(any))
            .thenReturn(MockedStreamSubscription());
        when(mockedProfileBloc.state).thenReturn(CompleteProfileState(null));
        when(mockedCollectionsBloc.state)
            .thenReturn(LoadedCollectionsState(collections: []));
        return NewCollectionBloc(
          collectionsFacade: mockedCollectionsFacade,
          profileBloc: mockedProfileBloc,
          collectionsBloc: mockedCollectionsBloc,
          inAppPurchaseBloc: mockedInAppPurchaseBloc,
        );
      },
      act: (NewCollectionBloc bloc) async => bloc
        ..add(SubtitleChangedNewCollectionEvent('subtitle'))
        ..add(DescriptionChangedNewCollectionEvent('description'))
        ..add(SubmitNewCollectionEvent()),
      expect: [
        GeneralNewCollectionState(subtitle: Subtitle('subtitle')),
        GeneralNewCollectionState(
            subtitle: Subtitle('subtitle'),
            description: model.Description('description')),
        GeneralNewCollectionState(
            subtitle: Subtitle('subtitle'),
            description: model.Description('description'),
            isSubmitting: true),
        GeneralNewCollectionState(
            subtitle: Subtitle('subtitle'),
            description: model.Description('description'),
            isSubmitting: false,
            showErrorMessages: true),
      ],
    );

    blocTest(
      'should do nothing if subtitle is not valid',
      build: () async {
        when(mockedInAppPurchaseBloc.listen(any))
            .thenReturn(MockedStreamSubscription());
        when(mockedProfileBloc.state).thenReturn(CompleteProfileState(null));
        when(mockedCollectionsBloc.state)
            .thenReturn(LoadedCollectionsState(collections: []));
        return NewCollectionBloc(
          collectionsFacade: mockedCollectionsFacade,
          profileBloc: mockedProfileBloc,
          collectionsBloc: mockedCollectionsBloc,
          inAppPurchaseBloc: mockedInAppPurchaseBloc,
        );
      },
      act: (NewCollectionBloc bloc) async => bloc
        ..add(TitleChangedNewCollectionEvent('title'))
        ..add(DescriptionChangedNewCollectionEvent('description'))
        ..add(SubmitNewCollectionEvent()),
      expect: [
        GeneralNewCollectionState(title: Title('title')),
        GeneralNewCollectionState(
            title: Title('title'),
            description: model.Description('description')),
        GeneralNewCollectionState(
            title: Title('title'),
            description: model.Description('description'),
            isSubmitting: true),
        GeneralNewCollectionState(
            title: Title('title'),
            description: model.Description('description'),
            isSubmitting: false,
            showErrorMessages: true),
      ],
    );

    blocTest(
      'should do nothing if description is not valid',
      build: () async {
        when(mockedInAppPurchaseBloc.listen(any))
            .thenReturn(MockedStreamSubscription());
        when(mockedProfileBloc.state).thenReturn(CompleteProfileState(null));
        when(mockedCollectionsBloc.state)
            .thenReturn(LoadedCollectionsState(collections: []));
        return NewCollectionBloc(
          collectionsFacade: mockedCollectionsFacade,
          profileBloc: mockedProfileBloc,
          collectionsBloc: mockedCollectionsBloc,
          inAppPurchaseBloc: mockedInAppPurchaseBloc,
        );
      },
      act: (NewCollectionBloc bloc) async => bloc
        ..add(TitleChangedNewCollectionEvent('title'))
        ..add(SubtitleChangedNewCollectionEvent('subtitle'))
        ..add(SubmitNewCollectionEvent()),
      expect: [
        GeneralNewCollectionState(title: Title('title')),
        GeneralNewCollectionState(
            title: Title('title'), subtitle: Subtitle('subtitle')),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            isSubmitting: true),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            isSubmitting: false,
            showErrorMessages: true),
      ],
    );

    blocTest(
      'should call CollectionsFacade if collection does not exist',
      build: () async {
        when(mockedInAppPurchaseBloc.listen(any))
            .thenReturn(MockedStreamSubscription());
        when(mockedFile.path).thenReturn('thumnail.jpg');
        when(mockedProfileBloc.state).thenReturn(CompleteProfileState(
          UserProfile(
            email: 'email',
            userUid: 'userUid',
            username: 'username',
            firstName: 'firstName',
            lastName: 'lastName',
          ),
        ));
        when(mockedCollectionsBloc.state)
            .thenReturn(LoadedCollectionsState(collections: []));
        return NewCollectionBloc(
          collectionsFacade: mockedCollectionsFacade,
          profileBloc: mockedProfileBloc,
          collectionsBloc: mockedCollectionsBloc,
          inAppPurchaseBloc: mockedInAppPurchaseBloc,
        );
      },
      act: (NewCollectionBloc bloc) async => bloc
        ..add(TitleChangedNewCollectionEvent('title'))
        ..add(SubtitleChangedNewCollectionEvent('subtitle'))
        ..add(DescriptionChangedNewCollectionEvent('description'))
        ..add(ImageChangedNewCollectionEvent(mockedFile))
        ..add(SubmitNewCollectionEvent()),
      verify: (_) async =>
          verify(mockedCollectionsFacade.addCollection(Collection(
        id: 'title',
        title: 'title',
        subtitle: 'subtitle',
        description: 'description',
        owner: 'username',
        thumbnail: null, // not in props
      ))).called(1),
    );

    blocTest(
      'should upload image on successful item adding',
      build: () async {
        when(mockedInAppPurchaseBloc.listen(any))
            .thenReturn(MockedStreamSubscription());
        when(mockedFile.path).thenReturn('thumnail.jpg');
        when(mockedProfileBloc.state).thenReturn(CompleteProfileState(
          UserProfile(
            email: 'email',
            userUid: 'userUid',
            username: 'username',
            firstName: 'firstName',
            lastName: 'lastName',
          ),
        ));
        when(mockedCollectionsFacade.addCollection(any))
            .thenAnswer((_) async => Right(null));
        when(mockedCollectionsBloc.state)
            .thenReturn(LoadedCollectionsState(collections: []));
        return NewCollectionBloc(
          collectionsFacade: mockedCollectionsFacade,
          profileBloc: mockedProfileBloc,
          collectionsBloc: mockedCollectionsBloc,
          inAppPurchaseBloc: mockedInAppPurchaseBloc,
        );
      },
      act: (NewCollectionBloc bloc) async => bloc
        ..add(TitleChangedNewCollectionEvent('title'))
        ..add(SubtitleChangedNewCollectionEvent('subtitle'))
        ..add(DescriptionChangedNewCollectionEvent('description'))
        ..add(ImageChangedNewCollectionEvent(mockedFile))
        ..add(SubmitNewCollectionEvent()),
      verify: (_) async => verify(
        mockedCollectionsFacade.uploadCollectionThumbnail(
          image: mockedFile,
          destinationName:
              getCollectionThumbnailName('username', 'title', 'jpg'),
        ),
      ).called(1),
    );

    blocTest(
      'should refresh collections list on successfully added item and uploaded image',
      build: () async {
        when(mockedInAppPurchaseBloc.listen(any))
            .thenReturn(MockedStreamSubscription());
        when(mockedFile.path).thenReturn('thumnail.jpg');
        when(mockedProfileBloc.state).thenReturn(CompleteProfileState(
          UserProfile(
            email: 'email',
            userUid: 'userUid',
            username: 'username',
            firstName: 'firstName',
            lastName: 'lastName',
          ),
        ));
        when(mockedCollectionsFacade.uploadCollectionThumbnail(
                image: anyNamed('image'),
                destinationName: anyNamed('destinationName')))
            .thenAnswer((_) async => Right(null));
        when(mockedCollectionsFacade.addCollection(any))
            .thenAnswer((_) async => Right(null));
        when(mockedCollectionsBloc.state)
            .thenReturn(LoadedCollectionsState(collections: []));
        return NewCollectionBloc(
          collectionsFacade: mockedCollectionsFacade,
          profileBloc: mockedProfileBloc,
          collectionsBloc: mockedCollectionsBloc,
          inAppPurchaseBloc: mockedInAppPurchaseBloc,
        );
      },
      act: (NewCollectionBloc bloc) async => bloc
        ..add(TitleChangedNewCollectionEvent('title'))
        ..add(SubtitleChangedNewCollectionEvent('subtitle'))
        ..add(DescriptionChangedNewCollectionEvent('description'))
        ..add(ImageChangedNewCollectionEvent(mockedFile))
        ..add(SubmitNewCollectionEvent()),
      verify: (_) async => verify(mockedCollectionsBloc
              .add(GetCollectionsEvent(username: 'username')))
          .called(1),
    );

    blocTest(
      'should update premium collection count on valid premium collection submission',
      build: () async {
        when(mockedInAppPurchaseBloc.listen(any))
            .thenReturn(MockedStreamSubscription());
        when(mockedFile.path).thenReturn('thumnail.jpg');
        when(mockedProfileBloc.canCreatePremiumCollection()).thenReturn(true);
        when(mockedProfileBloc.state).thenReturn(CompleteProfileState(
          UserProfile(
            email: 'email',
            userUid: 'userUid',
            username: 'username',
            firstName: 'firstName',
            lastName: 'lastName',
          ),
        ));
        when(mockedCollectionsFacade.uploadCollectionThumbnail(
                image: anyNamed('image'),
                destinationName: anyNamed('destinationName')))
            .thenAnswer((_) async => Right(null));
        when(mockedCollectionsFacade.addCollection(any))
            .thenAnswer((_) async => Right(null));
        when(mockedCollectionsBloc.state)
            .thenReturn(LoadedCollectionsState(collections: []));
        return NewCollectionBloc(
          collectionsFacade: mockedCollectionsFacade,
          profileBloc: mockedProfileBloc,
          collectionsBloc: mockedCollectionsBloc,
          inAppPurchaseBloc: mockedInAppPurchaseBloc,
        );
      },
      act: (NewCollectionBloc bloc) async => bloc
        ..add(TitleChangedNewCollectionEvent('title'))
        ..add(SubtitleChangedNewCollectionEvent('subtitle'))
        ..add(DescriptionChangedNewCollectionEvent('description'))
        ..add(ImageChangedNewCollectionEvent(mockedFile))
        ..add(IsPremiumChangedNewCollectionEvent())
        ..add(SubmitNewCollectionEvent()),
      verify: (_) async =>
          verify(mockedProfileBloc.changePremiumCollectionsAvailable(by: -1))
              .called(1),
    );

    blocTest(
      'should have Left(NotUpdatedPremiumCollectionCount) when failed to update premium collection count',
      build: () async {
        when(mockedInAppPurchaseBloc.listen(any))
            .thenReturn(MockedStreamSubscription());
        when(mockedFile.path).thenReturn('thumnail.jpg');
        when(mockedProfileBloc.canCreatePremiumCollection()).thenReturn(true);
        when(mockedProfileBloc.changePremiumCollectionsAvailable(
                by: anyNamed('by')))
            .thenAnswer((_) async => false);
        when(mockedProfileBloc.state).thenReturn(CompleteProfileState(
          UserProfile(
            email: 'email',
            userUid: 'userUid',
            username: 'username',
            firstName: 'firstName',
            lastName: 'lastName',
          ),
        ));
        when(mockedCollectionsFacade.uploadCollectionThumbnail(
                image: anyNamed('image'),
                destinationName: anyNamed('destinationName')))
            .thenAnswer((_) async => Right(null));
        when(mockedCollectionsFacade.addCollection(any))
            .thenAnswer((_) async => Right(null));
        when(mockedCollectionsBloc.state)
            .thenReturn(LoadedCollectionsState(collections: []));
        return NewCollectionBloc(
          collectionsFacade: mockedCollectionsFacade,
          profileBloc: mockedProfileBloc,
          collectionsBloc: mockedCollectionsBloc,
          inAppPurchaseBloc: mockedInAppPurchaseBloc,
        );
      },
      act: (NewCollectionBloc bloc) async => bloc
        ..add(TitleChangedNewCollectionEvent('title'))
        ..add(SubtitleChangedNewCollectionEvent('subtitle'))
        ..add(DescriptionChangedNewCollectionEvent('description'))
        ..add(ImageChangedNewCollectionEvent(mockedFile))
        ..add(IsPremiumChangedNewCollectionEvent())
        ..add(SubmitNewCollectionEvent()),
      expect: [
        GeneralNewCollectionState(title: Title('title')),
        GeneralNewCollectionState(
            title: Title('title'), subtitle: Subtitle('subtitle')),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description')),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description'),
            thumbnail: Photo(mockedFile)),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description'),
            thumbnail: Photo(mockedFile),
            isPremium: true),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description'),
            thumbnail: Photo(mockedFile),
            isPremium: true,
            isSubmitting: true),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description'),
            thumbnail: Photo(mockedFile),
            isPremium: true,
            isSubmitting: false,
            showErrorMessages: true,
            dataFailure: Left(NotUpdatedPremiumCollectionCountDataFailure())),
      ],
    );

    blocTest(
      'should have state.dataFailure as Right on success',
      build: () async {
        when(mockedInAppPurchaseBloc.listen(any))
            .thenReturn(MockedStreamSubscription());
        when(mockedFile.path).thenReturn('thumnail.jpg');
        when(mockedProfileBloc.state).thenReturn(CompleteProfileState(
          UserProfile(
            email: 'email',
            userUid: 'userUid',
            username: 'username',
            firstName: 'firstName',
            lastName: 'lastName',
          ),
        ));
        when(mockedCollectionsFacade.uploadCollectionThumbnail(
                image: anyNamed('image'),
                destinationName: anyNamed('destinationName')))
            .thenAnswer((_) async => Right(null));
        when(mockedCollectionsFacade.addCollection(any))
            .thenAnswer((_) async => Right(null));
        when(mockedCollectionsBloc.state)
            .thenReturn(LoadedCollectionsState(collections: []));
        return NewCollectionBloc(
          collectionsFacade: mockedCollectionsFacade,
          profileBloc: mockedProfileBloc,
          collectionsBloc: mockedCollectionsBloc,
          inAppPurchaseBloc: mockedInAppPurchaseBloc,
        );
      },
      act: (NewCollectionBloc bloc) async => bloc
        ..add(TitleChangedNewCollectionEvent('title'))
        ..add(SubtitleChangedNewCollectionEvent('subtitle'))
        ..add(DescriptionChangedNewCollectionEvent('description'))
        ..add(ImageChangedNewCollectionEvent(mockedFile))
        ..add(SubmitNewCollectionEvent()),
      expect: [
        GeneralNewCollectionState(title: Title('title')),
        GeneralNewCollectionState(
            title: Title('title'), subtitle: Subtitle('subtitle')),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description')),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description'),
            thumbnail: Photo(mockedFile)),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description'),
            thumbnail: Photo(mockedFile),
            isSubmitting: true),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description'),
            thumbnail: Photo(mockedFile),
            isSubmitting: false,
            showErrorMessages: true,
            dataFailure: Right(null)),
      ],
    );

    blocTest(
      'should have message about collection exists in DataFailure if collection exists',
      build: () async {
        when(mockedInAppPurchaseBloc.listen(any))
            .thenReturn(MockedStreamSubscription());
        when(mockedFile.path).thenReturn('thumnail.jpg');
        when(mockedProfileBloc.state).thenReturn(CompleteProfileState(
          UserProfile(
            email: 'email',
            userUid: 'userUid',
            username: 'username',
            firstName: 'firstName',
            lastName: 'lastName',
          ),
        ));
        when(mockedCollectionsBloc.state).thenReturn(LoadedCollectionsState(
          collections: [
            Collection(
              id: 'title',
              owner: 'username',
              title: 'title',
              subtitle: 'subtitle',
              description: 'description',
              thumbnail: '',
            )
          ],
        ));
        return NewCollectionBloc(
          collectionsFacade: mockedCollectionsFacade,
          profileBloc: mockedProfileBloc,
          collectionsBloc: mockedCollectionsBloc,
          inAppPurchaseBloc: mockedInAppPurchaseBloc,
        );
      },
      act: (NewCollectionBloc bloc) async => bloc
        ..add(TitleChangedNewCollectionEvent('title'))
        ..add(SubtitleChangedNewCollectionEvent('subtitle'))
        ..add(DescriptionChangedNewCollectionEvent('description'))
        ..add(ImageChangedNewCollectionEvent(mockedFile))
        ..add(SubmitNewCollectionEvent()),
      expect: [
        GeneralNewCollectionState(title: Title('title')),
        GeneralNewCollectionState(
            title: Title('title'), subtitle: Subtitle('subtitle')),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description')),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description'),
            thumbnail: Photo(mockedFile)),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description'),
            thumbnail: Photo(mockedFile),
            isSubmitting: true),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description'),
            thumbnail: Photo(mockedFile),
            isSubmitting: false,
            showErrorMessages: true,
            dataFailure:
                Left(DataFailure(message: Translation.collectionTitleExists))),
      ],
    );

    blocTest(
      'should have state.dataFailure as Left on failed item save',
      build: () async {
        when(mockedInAppPurchaseBloc.listen(any))
            .thenReturn(MockedStreamSubscription());
        when(mockedFile.path).thenReturn('thumnail.jpg');
        when(mockedProfileBloc.state).thenReturn(CompleteProfileState(
          UserProfile(
            email: 'email',
            userUid: 'userUid',
            username: 'username',
            firstName: 'firstName',
            lastName: 'lastName',
          ),
        ));
        when(mockedCollectionsFacade.addCollection(any))
            .thenAnswer((_) async => Left(DataFailure()));
        when(mockedCollectionsBloc.state)
            .thenReturn(LoadedCollectionsState(collections: []));
        return NewCollectionBloc(
          collectionsFacade: mockedCollectionsFacade,
          profileBloc: mockedProfileBloc,
          collectionsBloc: mockedCollectionsBloc,
          inAppPurchaseBloc: mockedInAppPurchaseBloc,
        );
      },
      act: (NewCollectionBloc bloc) async => bloc
        ..add(TitleChangedNewCollectionEvent('title'))
        ..add(SubtitleChangedNewCollectionEvent('subtitle'))
        ..add(DescriptionChangedNewCollectionEvent('description'))
        ..add(ImageChangedNewCollectionEvent(mockedFile))
        ..add(SubmitNewCollectionEvent()),
      expect: [
        GeneralNewCollectionState(title: Title('title')),
        GeneralNewCollectionState(
            title: Title('title'), subtitle: Subtitle('subtitle')),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description')),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description'),
            thumbnail: Photo(mockedFile)),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description'),
            thumbnail: Photo(mockedFile),
            isSubmitting: true),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description'),
            thumbnail: Photo(mockedFile),
            isSubmitting: false,
            showErrorMessages: true,
            dataFailure: Left(DataFailure())),
      ],
    );

    blocTest(
      'should update back premium collection count on failed item save',
      build: () async {
        when(mockedInAppPurchaseBloc.listen(any))
            .thenReturn(MockedStreamSubscription());
        when(mockedFile.path).thenReturn('thumnail.jpg');
        when(mockedProfileBloc.canCreatePremiumCollection()).thenReturn(true);
        when(mockedProfileBloc.changePremiumCollectionsAvailable(
                by: anyNamed('by')))
            .thenAnswer((_) async => true);
        when(mockedProfileBloc.state).thenReturn(CompleteProfileState(
          UserProfile(
            email: 'email',
            userUid: 'userUid',
            username: 'username',
            firstName: 'firstName',
            lastName: 'lastName',
          ),
        ));
        when(mockedCollectionsFacade.addCollection(any))
            .thenAnswer((_) async => Left(DataFailure()));
        when(mockedCollectionsBloc.state)
            .thenReturn(LoadedCollectionsState(collections: []));
        return NewCollectionBloc(
          collectionsFacade: mockedCollectionsFacade,
          profileBloc: mockedProfileBloc,
          collectionsBloc: mockedCollectionsBloc,
          inAppPurchaseBloc: mockedInAppPurchaseBloc,
        );
      },
      act: (NewCollectionBloc bloc) async => bloc
        ..add(TitleChangedNewCollectionEvent('title'))
        ..add(SubtitleChangedNewCollectionEvent('subtitle'))
        ..add(DescriptionChangedNewCollectionEvent('description'))
        ..add(ImageChangedNewCollectionEvent(mockedFile))
        ..add(IsPremiumChangedNewCollectionEvent())
        ..add(SubmitNewCollectionEvent()),
      verify: (_) async =>
          verify(mockedProfileBloc.changePremiumCollectionsAvailable(by: 1))
              .called(1),
    );

    blocTest(
      'should have state.dataFailure as Left on failed thumbnail upload',
      build: () async {
        when(mockedInAppPurchaseBloc.listen(any))
            .thenReturn(MockedStreamSubscription());
        when(mockedFile.path).thenReturn('thumnail.jpg');
        when(mockedProfileBloc.state).thenReturn(CompleteProfileState(
          UserProfile(
            email: 'email',
            userUid: 'userUid',
            username: 'username',
            firstName: 'firstName',
            lastName: 'lastName',
          ),
        ));
        when(mockedCollectionsFacade.uploadCollectionThumbnail(
                image: anyNamed('image'),
                destinationName: anyNamed('destinationName')))
            .thenAnswer((_) async => Left(DataFailure()));
        when(mockedCollectionsFacade.addCollection(any))
            .thenAnswer((_) async => Right(null));
        when(mockedCollectionsBloc.state)
            .thenReturn(LoadedCollectionsState(collections: []));
        return NewCollectionBloc(
          collectionsFacade: mockedCollectionsFacade,
          profileBloc: mockedProfileBloc,
          collectionsBloc: mockedCollectionsBloc,
          inAppPurchaseBloc: mockedInAppPurchaseBloc,
        );
      },
      act: (NewCollectionBloc bloc) async => bloc
        ..add(TitleChangedNewCollectionEvent('title'))
        ..add(SubtitleChangedNewCollectionEvent('subtitle'))
        ..add(DescriptionChangedNewCollectionEvent('description'))
        ..add(ImageChangedNewCollectionEvent(mockedFile))
        ..add(SubmitNewCollectionEvent()),
      expect: [
        GeneralNewCollectionState(title: Title('title')),
        GeneralNewCollectionState(
            title: Title('title'), subtitle: Subtitle('subtitle')),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description')),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description'),
            thumbnail: Photo(mockedFile)),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description'),
            thumbnail: Photo(mockedFile),
            isSubmitting: true),
        GeneralNewCollectionState(
            title: Title('title'),
            subtitle: Subtitle('subtitle'),
            description: model.Description('description'),
            thumbnail: Photo(mockedFile),
            isSubmitting: false,
            showErrorMessages: true,
            dataFailure: Left(DataFailure())),
      ],
    );
  });

  group('IsPremiumChanged', () {
    blocTest(
      'should yield nothing if cannot create premium collection',
      build: () async {
        when(mockedInAppPurchaseBloc.listen(any))
            .thenReturn(MockedStreamSubscription());
        when(mockedProfileBloc.canCreatePremiumCollection()).thenReturn(false);
        return NewCollectionBloc(
          collectionsFacade: mockedCollectionsFacade,
          profileBloc: mockedProfileBloc,
          collectionsBloc: mockedCollectionsBloc,
          inAppPurchaseBloc: mockedInAppPurchaseBloc,
        );
      },
      act: (NewCollectionBloc bloc) async =>
          bloc.add(IsPremiumChangedNewCollectionEvent()),
      expect: [],
    );

    blocTest(
      'should yield state with switched premium if can create premium collection',
      build: () async {
        when(mockedInAppPurchaseBloc.listen(any))
            .thenReturn(MockedStreamSubscription());
        when(mockedProfileBloc.canCreatePremiumCollection()).thenReturn(true);
        return NewCollectionBloc(
          collectionsFacade: mockedCollectionsFacade,
          profileBloc: mockedProfileBloc,
          collectionsBloc: mockedCollectionsBloc,
          inAppPurchaseBloc: mockedInAppPurchaseBloc,
        );
      },
      act: (NewCollectionBloc bloc) async => bloc
        ..add(IsPremiumChangedNewCollectionEvent())
        ..add(IsPremiumChangedNewCollectionEvent()),
      expect: [
        GeneralNewCollectionState(isPremium: true),
        GeneralNewCollectionState(isPremium: false),
      ],
    );
  });
}
