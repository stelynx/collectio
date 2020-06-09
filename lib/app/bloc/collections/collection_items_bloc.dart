import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../facade/collections/collections_facade.dart';
import '../../../model/collection.dart';
import '../../../model/collection_item.dart';
import '../../../util/constant/constants.dart';
import '../../../util/error/data_failure.dart';

part 'collection_items_event.dart';
part 'collection_items_state.dart';

/// Bloc used for displaying items in a collection.
@prod
@lazySingleton
class CollectionItemsBloc
    extends Bloc<CollectionItemsEvent, CollectionItemsState> {
  CollectionsFacade _collectionsFacade;

  CollectionItemsBloc({@required CollectionsFacade collectionsFacade})
      : _collectionsFacade = collectionsFacade;

  @override
  CollectionItemsState get initialState => InitialCollectionItemsState();

  @override
  Stream<CollectionItemsState> mapEventToState(
    CollectionItemsEvent event,
  ) async* {
    if (event is GetCollectionItemsEvent) {
      yield LoadingCollectionItemsState();

      final Either<DataFailure, List<CollectionItem>> itemsOrFailure =
          await _collectionsFacade.getItemsInCollection(event.collection);

      if (itemsOrFailure.isRight()) {
        final List<CollectionItem> items = itemsOrFailure.getOrElse(() => null);
        yield LoadedCollectionItemsState(items..sort(CollectionItem.compare));
      } else {
        yield ErrorCollectionItemsState();
      }
    } else if (event is DeleteItemCollectionItemsEvent) {
      if (state is LoadedCollectionItemsState) {
        final Either<DataFailure, void> result = await _collectionsFacade
            .deleteItemInCollection(collectionItem: event.item);

        if (result.isRight()) {
          final List<CollectionItem> items =
              (state as LoadedCollectionItemsState).collectionItems;
          items.remove(event.item);

          yield LoadedCollectionItemsState(
            items,
            toastMessage: Constants.collectionItemDeleted,
          );
        } else {
          yield LoadedCollectionItemsState(
            (state as LoadedCollectionItemsState).collectionItems,
            toastMessage: Constants.collectionItemDeletionFailed,
          );
        }
      }
    }
  }
}

@test
@lazySingleton
@RegisterAs(CollectionItemsBloc)
class MockedCollectionItemsBloc
    extends MockBloc<CollectionItemsEvent, CollectionItemsState>
    implements CollectionItemsBloc {}
