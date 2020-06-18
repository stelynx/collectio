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
import '../../../util/constant/translation.dart';
import '../../../util/error/data_failure.dart';
import '../../widgets/collectio_toast.dart';

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
        yield LoadedCollectionItemsState(
            collectionItems: items..sort(CollectionItem.compare));
      } else {
        yield ErrorCollectionItemsState();
      }
    } else if (event is DeleteItemCollectionItemsEvent) {
      if (state is LoadedCollectionItemsState) {
        final List<CollectionItem> items =
            (state as LoadedCollectionItemsState).collectionItems;
        final int itemIndex = items.indexOf(event.item);
        items.removeAt(itemIndex);

        yield LoadedCollectionItemsState(collectionItems: items);

        final Either<DataFailure, void> result = await _collectionsFacade
            .deleteItemInCollection(collectionItem: event.item);

        if (result.isRight()) {
          yield LoadedCollectionItemsState(
            collectionItems: items,
            toastMessage: Translation.collectionItemDeleted,
            toastType: ToastType.success,
          );
        } else {
          items.insert(itemIndex, event.item);
          yield LoadedCollectionItemsState(
            collectionItems:
                (state as LoadedCollectionItemsState).collectionItems,
            toastMessage: Translation.collectionItemDeletionFailed,
            toastType: ToastType.error,
          );
        }
      }
    } else if (event is ToggleSearchCollectionItemsEvent) {
      if (state is LoadedCollectionItemsState) {
        yield LoadedCollectionItemsState(
          collectionItems:
              (state as LoadedCollectionItemsState).collectionItems,
          isSearching: !(state as LoadedCollectionItemsState).isSearching,
        );
      }
    } else if (event is SearchQueryChangedCollectionItemsEvent) {
      if (state is LoadedCollectionItemsState) {
        final List<CollectionItem> collectionItems =
            (state as LoadedCollectionItemsState).collectionItems;

        yield LoadedCollectionItemsState(
          collectionItems: collectionItems,
          displayedCollectionItems: collectionItems
              .where((CollectionItem collectionItem) => collectionItem.title
                  .toLowerCase()
                  .contains(event.searchQuery.toLowerCase()))
              .toList(),
          isSearching: true,
        );
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
