import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../facade/collections/collections_facade.dart';
import '../../../model/collection.dart';
import '../../../util/constant/constants.dart';
import '../../../util/error/data_failure.dart';
import '../profile/profile_bloc.dart';

part 'collections_event.dart';
part 'collections_state.dart';

@prod
@lazySingleton
class CollectionsBloc extends Bloc<CollectionsEvent, CollectionsState> {
  final CollectionsFacade _collectionsFacade;
  final ProfileBloc _profileBloc;
  StreamSubscription _profileBlocStreamSubscription;

  CollectionsBloc(
      {@required CollectionsFacade collectionsFacade,
      @required ProfileBloc profileBloc})
      : _collectionsFacade = collectionsFacade,
        _profileBloc = profileBloc {
    _profileBlocStreamSubscription = _profileBloc.listen((ProfileState state) {
      if (state is CompleteProfileState) {
        this.add(GetCollectionsEvent(username: state.userProfile.username));
      } else if (state is EmptyProfileState) {
        this.add(ResetCollectionsEvent());
      }
    });
  }

  @override
  Future<void> close() {
    _profileBlocStreamSubscription.cancel();
    return super.close();
  }

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
        (List<Collection> collections) => LoadedCollectionsState(
            collections: collections..sort(Collection.compare)),
      );
    } else if (event is DeleteCollectionCollectionsEvent) {
      if (state is LoadedCollectionsState) {
        final Either<DataFailure, void> result =
            await _collectionsFacade.deleteCollection(event.collection);

        if (result.isRight()) {
          final List<Collection> collections =
              (state as LoadedCollectionsState).collections;
          collections.remove(event.collection);

          yield LoadedCollectionsState(
            collections: collections,
            toastMessage: Constants.collectionDeleted,
          );
        } else {
          yield LoadedCollectionsState(
            collections: (state as LoadedCollectionsState).collections,
            toastMessage: Constants.collectionDeletionFailed,
          );
        }
      }
    } else if (event is ResetCollectionsEvent) {
      yield EmptyCollectionsState();
    }
  }
}

@test
@lazySingleton
@RegisterAs(CollectionsBloc)
class MockedCollectionsBloc extends MockBloc<CollectionsEvent, CollectionsState>
    implements CollectionsBloc {}
