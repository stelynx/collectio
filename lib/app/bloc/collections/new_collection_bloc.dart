import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../facade/collections/collections_facade.dart';
import '../../../model/collection.dart';
import '../../../model/value_object/description.dart';
import '../../../model/value_object/subtitle.dart';
import '../../../model/value_object/title.dart';
import '../../../util/constant/constants.dart';
import '../../../util/error/data_failure.dart';
import '../../../util/function/id_generator.dart';
import '../../../util/function/listable_finder.dart';
import '../profile/profile_bloc.dart';
import 'collections_bloc.dart';

part 'new_collection_event.dart';
part 'new_collection_state.dart';

@prod
@lazySingleton
class NewCollectionBloc extends Bloc<NewCollectionEvent, NewCollectionState> {
  final CollectionsFacade _collectionsFacade;
  final CollectionsBloc _collectionsBloc;
  final ProfileBloc _profileBloc;

  NewCollectionBloc({
    @required CollectionsFacade collectionsFacade,
    @required ProfileBloc profileBloc,
    @required CollectionsBloc collectionsBloc,
  })  : _collectionsFacade = collectionsFacade,
        _profileBloc = profileBloc,
        _collectionsBloc = collectionsBloc;

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
    } else if (event is SubmitNewCollectionEvent) {
      yield state.copyWith(isSubmitting: true);

      if (_profileBloc.state is CompleteProfileState &&
          _collectionsBloc.state is LoadedCollectionsState &&
          state.title.isValid() &&
          state.subtitle.isValid() &&
          state.description.isValid()) {
        CompleteProfileState completeProfileState =
            _profileBloc.state as CompleteProfileState;
        LoadedCollectionsState loadedCollectionsState =
            _collectionsBloc.state as LoadedCollectionsState;

        if (ListableFinder.findById(
                loadedCollectionsState.collections, state.id) ==
            null) {
          final Collection newCollection = Collection(
            id: state.id,
            owner: completeProfileState.userProfile.username,
            title: state.title.get(),
            subtitle: state.subtitle.get(),
            description: state.description.get(),
            thumbnail: state.thumbnail,
          );

          final Either<DataFailure, void> result =
              await _collectionsFacade.addCollection(newCollection);

          if (result.isRight())
            _collectionsBloc.add(GetCollectionsEvent(
                username: completeProfileState.userProfile.username));

          yield state.copyWith(
            isSubmitting: false,
            showErrorMessages: true,
            dataFailure: result,
          );
        } else {
          yield state.copyWith(
              isSubmitting: false,
              showErrorMessages: true,
              dataFailure:
                  Left(DataFailure(message: Constants.collectionTitleExists)));
        }
      } else {
        yield state.copyWith(isSubmitting: false, showErrorMessages: true);
      }
    }
  }
}

@test
@lazySingleton
@RegisterAs(NewCollectionBloc)
class MockedNewCollectionBloc
    extends MockBloc<NewCollectionEvent, NewCollectionState>
    implements NewCollectionBloc {}