import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../facade/collections/collections_facade.dart';
import '../../../model/collection_item.dart';
import '../../../util/error/data_failure.dart';

part 'collection_items_event.dart';
part 'collection_items_state.dart';

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
      final Either<DataFailure, List<CollectionItem>> items =
          await _collectionsFacade.getItemsInCollection(
              event.collectionOwner, event.collectionName);

      if (items.isRight()) {
        yield LoadedCollectionItemsState(items.getOrElse(null));
      } else {
        yield ErrorCollectionItemsState();
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
