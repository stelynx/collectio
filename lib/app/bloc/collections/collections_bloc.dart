import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../facade/collections/collections_facade.dart';
import '../../../model/collection.dart';
import '../../../util/error/data_failure.dart';

part 'collections_event.dart';
part 'collections_state.dart';

@prod
@lazySingleton
class CollectionsBloc extends Bloc<CollectionsEvent, CollectionsState> {
  final CollectionsFacade _collectionsFacade;

  CollectionsBloc({@required CollectionsFacade collectionsFacade})
      : _collectionsFacade = collectionsFacade;

  @override
  CollectionsState get initialState => InitialCollectionsState();

  @override
  Stream<CollectionsState> mapEventToState(
    CollectionsEvent event,
  ) async* {
    if (event is GetCollectionsEvent) {
      yield LoadingCollectionsState();

      final Either<DataFailure, List<Collection>> collectionsOrFailure =
          await _collectionsFacade.getCollectionsForUser(event.username);

      yield collectionsOrFailure.fold<CollectionsState>(
        (_) => ErrorCollectionsState(),
        (List<Collection> collections) =>
            LoadedCollectionsState(collections: collections),
      );
    }
  }
}

@test
@lazySingleton
@RegisterAs(CollectionsBloc)
class MockedCollectionsBloc extends MockBloc<CollectionsEvent, CollectionsState>
    implements CollectionsBloc {}