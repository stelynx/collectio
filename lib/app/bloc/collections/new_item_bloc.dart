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
import 'collection_items_bloc.dart';

part 'new_item_event.dart';
part 'new_item_state.dart';

@prod
@lazySingleton
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
  Future<void> close() {
    print('CLOSED\n\n\n\n\n');
    return super.close();
  }

  @override
  Stream<NewItemState> mapEventToState(
    NewItemEvent event,
  ) async* {
    print(event);
    if (event is InitializeNewItemEvent) {
      yield InitialNewItemState().copyWith(
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
          state.raiting != null) {
        yield state.copyWith(isSubmitting: true);

        final CollectionItem collectionItem = CollectionItem(
          added: DateTime.now(),
          title: state.title.get(),
          subtitle: state.subtitle.get(),
          description: state.description.get(),
          imageUrl: '',
          raiting: state.raiting,
        );

        final Either<DataFailure, void> result =
            await _collectionsFacade.addItemToCollection(
                owner: state.owner,
                collectionName: state.collectionName,
                item: collectionItem);

        if (result.isRight()) {
          _collectionItemsBloc.add(GetCollectionItemsEvent(
            collectionOwner: state.owner,
            collectionName: state.collectionName,
          ));
        }

        yield state.copyWith(
          isSubmitting: false,
          showErrorMessages: true,
          dataFailure: result,
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
