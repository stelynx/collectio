import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../facade/collections/collections_facade.dart';
import '../../../model/collection_item.dart';
import '../../../model/value_object/description.dart';
import '../../../model/value_object/subtitle.dart';
import '../../../model/value_object/title.dart';
import '../../../util/error/data_failure.dart';
import '../../../util/function/image_name_generator.dart';
import 'collection_items_bloc.dart';

part 'new_item_event.dart';
part 'new_item_state.dart';

@prod
@injectable
class NewItemBloc extends Bloc<NewItemEvent, NewItemState> {
  final CollectionsFacade _collectionsFacade;
  final CollectionItemsBloc _collectionItemsBloc;

  NewItemBloc({
    @required CollectionsFacade collectionsFacade,
    @required CollectionItemsBloc collectionItemsBloc,
  })  : _collectionsFacade = collectionsFacade,
        _collectionItemsBloc = collectionItemsBloc;

  @override
  NewItemState get initialState => InitialNewItemState();

  @override
  Stream<NewItemState> mapEventToState(
    NewItemEvent event,
  ) async* {
    if (event is InitializeNewItemEvent) {
      yield state.copyWith(
        owner: event.owner,
        collectionName: event.collection,
      );
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
        localImage: event.image,
        dataFailure: null,
        overrideDataFailure: true,
      );
    } else if (event is SubmitNewItemEvent) {
      if (state.owner != null &&
          state.collectionName != null &&
          state.title.isValid() &&
          state.subtitle.isValid() &&
          state.description.isValid() &&
          state.raiting != null &&
          state.localImage != null) {
        yield state.copyWith(isSubmitting: true);

        final String fileExtension = state.localImage.path
            .substring(state.localImage.path.lastIndexOf('.') + 1);
        final String imageUrl = getItemImageName(
          state.owner,
          state.collectionName,
          state.title.get(),
          fileExtension,
        );

        final CollectionItem collectionItem = CollectionItem(
          added: DateTime.now(),
          title: state.title.get(),
          subtitle: state.subtitle.get(),
          description: state.description.get(),
          imageUrl: imageUrl,
          raiting: state.raiting,
        );

        final Either<DataFailure, void> result =
            await _collectionsFacade.addItemToCollection(
                owner: state.owner,
                collectionName: state.collectionName,
                item: collectionItem);

        Either<DataFailure, void> uploadResult;
        if (result.isRight()) {
          uploadResult = await _collectionsFacade.uploadCollectionItemImage(
              image: state.localImage, destinationName: imageUrl);

          if (uploadResult.isRight()) {
            _collectionItemsBloc.add(GetCollectionItemsEvent(
              collectionOwner: state.owner,
              collectionName: state.collectionName,
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
}

@test
@lazySingleton
@RegisterAs(NewItemBloc)
class MockedNewItemBloc extends MockBloc<NewItemEvent, NewItemState>
    implements NewItemBloc {}