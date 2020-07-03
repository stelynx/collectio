import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../facade/collections/collections_facade.dart';
import '../../../facade/maps/maps_facade.dart';
import '../../../model/collection.dart';
import '../../../model/collection_item.dart';
import '../../../model/image_metadata.dart';
import '../../../model/value_object/description.dart';
import '../../../model/value_object/photo.dart';
import '../../../model/value_object/subtitle.dart';
import '../../../model/value_object/title.dart';
import '../../../util/error/data_failure.dart';
import '../../../util/function/image_name_generator.dart';
import 'collection_items_bloc.dart';

part 'new_item_event.dart';
part 'new_item_state.dart';

/// Bloc used for new item form.
@prod
@injectable
class NewItemBloc extends Bloc<NewItemEvent, NewItemState> {
  final MapsFacade _mapsFacade;
  final CollectionsFacade _collectionsFacade;
  final CollectionItemsBloc _collectionItemsBloc;

  NewItemBloc({
    @required MapsFacade mapsFacade,
    @required CollectionsFacade collectionsFacade,
    @required CollectionItemsBloc collectionItemsBloc,
  })  : _mapsFacade = mapsFacade,
        _collectionsFacade = collectionsFacade,
        _collectionItemsBloc = collectionItemsBloc;

  @override
  NewItemState get initialState => InitialNewItemState();

  @override
  Stream<NewItemState> mapEventToState(
    NewItemEvent event,
  ) async* {
    if (event is InitializeNewItemEvent) {
      yield state.copyWith(collection: event.collection);
    } else if (event is TitleChangedNewItemEvent) {
      yield state.copyWith(
        title: Title(event.title),
        dataFailure: null,
        overrideDataFailure: true,
      );
    } else if (event is SubtitleChangedNewItemEvent) {
      yield state.copyWith(
        subtitle: Subtitle(event.subtitle),
        dataFailure: null,
        overrideDataFailure: true,
      );
    } else if (event is DescriptionChangedNewItemEvent) {
      yield state.copyWith(
        description: Description(event.description),
        dataFailure: null,
        overrideDataFailure: true,
      );
    } else if (event is RaitingChangedNewItemEvent) {
      yield state.copyWith(
        raiting: event.raiting,
        dataFailure: null,
        overrideDataFailure: true,
      );
    } else if (event is ImageChangedNewItemEvent) {
      yield state.copyWith(
        localImage: Photo(event.image),
        imageMetadata: event.metadata,
        overrideImageMetadata: true,
        dataFailure: null,
        overrideDataFailure: true,
      );
    } else if (event is LocationChangedNewItemEvent) {
      print('here');
      print(event.location);
      yield state.copyWith(
        location: event.location,
        dataFailure: null,
        overrideDataFailure: true,
      );
    } else if (event is SubmitNewItemEvent) {
      if (state.collection != null &&
          state.title.isValid() &&
          state.subtitle.isValid() &&
          state.description.isValid() &&
          state.raiting != null &&
          state.localImage.isValid()) {
        yield state.copyWith(isSubmitting: true);

        final DateTime now = DateTime.now();

        final String fileExtension = state.localImage
            .get()
            .path
            .substring(state.localImage.get().path.lastIndexOf('.') + 1);
        final String imageUrl = getItemImageName(
          state.collection.owner,
          state.collection.id,
          now.millisecondsSinceEpoch.toString(),
          fileExtension,
        );

        final CollectionItem collectionItem = CollectionItem(
          added: now,
          title: state.title.get(),
          subtitle: state.subtitle.get(),
          description: state.description.get(),
          imageUrl: imageUrl,
          raiting: state.raiting,
          imageMetadata: state.imageMetadata,
        );

        final Either<DataFailure, void> result =
            await _collectionsFacade.addItemToCollection(
                owner: state.collection.owner,
                collectionName: state.collection.id,
                item: collectionItem);

        Either<DataFailure, void> uploadResult;
        if (result.isRight()) {
          uploadResult = await _collectionsFacade.uploadCollectionItemImage(
              image: state.localImage.get(), destinationName: imageUrl);

          if (uploadResult.isRight()) {
            _collectionItemsBloc.add(GetCollectionItemsEvent(
              state.collection,
            ));
          }
        }

        yield state.copyWith(
          isSubmitting: false,
          showErrorMessages: true,
          dataFailure: result.isLeft() ? result : uploadResult,
        );
      } else {
        yield state.copyWith(showErrorMessages: true);
      }
    }
  }

  Future<Iterable<String>> getLocationSuggestions(String searchQuery) =>
      _mapsFacade.getSuggestionsFor(
        searchQuery,
        latitude: state.imageMetadata?.latitude,
        longitude: state.imageMetadata?.longitude,
      );

  Future<List<String>> getInitialSuggestions() =>
      _mapsFacade.getLocationsForLatLng(
        state.imageMetadata?.latitude,
        state.imageMetadata?.longitude,
      );
}

@test
@lazySingleton
@RegisterAs(NewItemBloc)
class MockedNewItemBloc extends MockBloc<NewItemEvent, NewItemState>
    implements NewItemBloc {}
