import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../facade/collections/collections_facade.dart';
import '../../../model/collection.dart';
import '../../../model/interface/listable.dart';
import '../../../model/value_object/description.dart';
import '../../../model/value_object/name.dart';
import '../../../model/value_object/photo.dart';
import '../../../model/value_object/subtitle.dart';
import '../../../model/value_object/title.dart';
import '../../../util/constant/translation.dart';
import '../../../util/error/data_failure.dart';
import '../../../util/function/id_generator.dart';
import '../../../util/function/image_name_generator.dart';
import '../../../util/function/listable_finder.dart';
import '../in_app_purchase/in_app_purchase_bloc.dart';
import '../profile/profile_bloc.dart';
import 'collections_bloc.dart';

part 'new_collection_event.dart';
part 'new_collection_state.dart';

/// Bloc used for new collection form.
@prod
@injectable
class NewCollectionBloc extends Bloc<NewCollectionEvent, NewCollectionState> {
  final CollectionsFacade _collectionsFacade;
  final CollectionsBloc _collectionsBloc;
  final ProfileBloc _profileBloc;
  final InAppPurchaseBloc _iapBloc;
  StreamSubscription _iapBlocStreamSubscription;

  NewCollectionBloc({
    @required CollectionsFacade collectionsFacade,
    @required ProfileBloc profileBloc,
    @required CollectionsBloc collectionsBloc,
    @required InAppPurchaseBloc inAppPurchaseBloc,
  })  : _collectionsFacade = collectionsFacade,
        _profileBloc = profileBloc,
        _collectionsBloc = collectionsBloc,
        _iapBloc = inAppPurchaseBloc {
    _iapBlocStreamSubscription = _iapBloc.listen((InAppPurchaseState state) {
      if (state.purchaseState == InAppPurchasePurchaseState.success) {
        this.add(IsPremiumChangedNewCollectionEvent());
      }
    });
  }

  @override
  Future<void> close() {
    _iapBlocStreamSubscription.cancel();
    return super.close();
  }

  @override
  NewCollectionState get initialState => InitialNewCollectionState();

  @override
  Stream<NewCollectionState> mapEventToState(
    NewCollectionEvent event,
  ) async* {
    if (event is TitleChangedNewCollectionEvent) {
      yield state.copyWith(
        title: Title(event.title),
        dataFailure: null,
        overrideDataFailure: true,
      );
    } else if (event is SubtitleChangedNewCollectionEvent) {
      yield state.copyWith(
        subtitle: Subtitle(event.subtitle),
        dataFailure: null,
        overrideDataFailure: true,
      );
    } else if (event is DescriptionChangedNewCollectionEvent) {
      yield state.copyWith(
        description: Description(event.description),
        dataFailure: null,
        overrideDataFailure: true,
      );
    } else if (event is ImageChangedNewCollectionEvent) {
      yield state.copyWith(
        thumbnail: Photo(event.image),
        dataFailure: null,
        overrideDataFailure: true,
      );
    } else if (event is IsPremiumChangedNewCollectionEvent) {
      if (!canCreatePremiumCollection()) return;

      yield state.copyWith(
        isPremium: !state.isPremium,
        dataFailure: null,
        overrideDataFailure: true,
      );
    } else if (event is ItemTitleNameChangedNewCollectionEvent) {
      yield state.copyWith(
        itemTitleName: Name(event.itemTitleName),
        dataFailure: null,
        overrideDataFailure: true,
      );
    } else if (event is ItemSubtitleNameChangedNewCollectionEvent) {
      yield state.copyWith(
        itemSubtitleName: Name(event.itemSubtitleName),
        dataFailure: null,
        overrideDataFailure: true,
      );
    } else if (event is ItemDescriptionNameChangedNewCollectionEvent) {
      yield state.copyWith(
        itemDescriptionName: Name(event.itemDescriptionName),
        dataFailure: null,
        overrideDataFailure: true,
      );
    } else if (event is SubmitNewCollectionEvent) {
      yield state.copyWith(isSubmitting: true);

      if (_profileBloc.state is CompleteProfileState &&
          _collectionsBloc.state is LoadedCollectionsState &&
          state.title.isValid() &&
          state.subtitle.isValid() &&
          state.description.isValid() &&
          state.thumbnail.isValid()) {
        final CompleteProfileState completeProfileState =
            _profileBloc.state as CompleteProfileState;
        final LoadedCollectionsState loadedCollectionsState =
            _collectionsBloc.state as LoadedCollectionsState;

        final Listable existingCollectionWithSameId = ListableFinder.findById(
          loadedCollectionsState.collections,
          state.id,
        );

        if (existingCollectionWithSameId == null) {
          if (state.isPremium) {
            final bool hasUpdatedPremiumCollectionCount =
                await _profileBloc.changePremiumCollectionsAvailable(by: -1);

            if (!hasUpdatedPremiumCollectionCount) {
              yield state.copyWith(
                isSubmitting: false,
                showErrorMessages: true,
                dataFailure:
                    Left(NotUpdatedPremiumCollectionCountDataFailure()),
              );
              return;
            }
          }

          final String fileExtension = state.thumbnail
              .get()
              .path
              .substring(state.thumbnail.get().path.lastIndexOf('.') + 1);
          final String imageUrl = getCollectionThumbnailName(
            completeProfileState.userProfile.username,
            state.id,
            fileExtension,
          );

          final Collection newCollection = Collection(
            id: state.id,
            owner: completeProfileState.userProfile.username,
            title: state.title.get(),
            subtitle: state.subtitle.get(),
            description: state.description.get(),
            thumbnail: imageUrl,
            isPremium: state.isPremium,
            itemTitleName: state.itemTitleName.get(),
            itemSubtitleName: state.itemSubtitleName.get(),
            itemDescriptionName: state.itemDescriptionName.get(),
          );

          final Either<DataFailure, void> result =
              await _collectionsFacade.addCollection(newCollection);

          Either<DataFailure, void> uploadResult;
          if (result.isRight()) {
            uploadResult = await _collectionsFacade.uploadCollectionThumbnail(
                image: state.thumbnail.get(), destinationName: imageUrl);

            if (uploadResult.isRight())
              _collectionsBloc.add(GetCollectionsEvent(
                  username: completeProfileState.userProfile.username));
          } else {
            // If saving the premium collection failed, increase the count back.
            if (state.isPremium) {
              await _profileBloc.changePremiumCollectionsAvailable(by: 1);
            }
          }

          yield state.copyWith(
            isSubmitting: false,
            showErrorMessages: true,
            dataFailure: result.isLeft() ? result : uploadResult,
          );
        } else {
          yield state.copyWith(
              isSubmitting: false,
              showErrorMessages: true,
              dataFailure: Left(
                  DataFailure(message: Translation.collectionTitleExists)));
        }
      } else {
        yield state.copyWith(isSubmitting: false, showErrorMessages: true);
      }
    }
  }

  bool canCreatePremiumCollection() =>
      _profileBloc.canCreatePremiumCollection();
}

@test
@lazySingleton
@RegisterAs(NewCollectionBloc)
class MockedNewCollectionBloc
    extends MockBloc<NewCollectionEvent, NewCollectionState>
    implements NewCollectionBloc {}
