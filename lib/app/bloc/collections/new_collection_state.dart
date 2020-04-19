part of 'new_collection_bloc.dart';

@immutable
abstract class NewCollectionState extends Equatable {
  final String id;
  final Title title;
  final Subtitle subtitle;
  final Description description;
  final String thumbnail;
  final bool showErrorMessages;
  final bool isSubmitting;
  final Either<DataFailure, void> dataFailure;

  NewCollectionState({
    @required this.title,
    @required this.subtitle,
    @required this.description,
    @required this.thumbnail,
    @required this.showErrorMessages,
    @required this.isSubmitting,
    @required this.dataFailure,
  }) : id = getId(title.get());

  NewCollectionState copyWith({
    Title title,
    Subtitle subtitle,
    Description description,
    String thumbnail,
    bool showErrorMessages,
    bool isSubmitting,
    Either<DataFailure, void> dataFailure,
    bool overrideDataFailure = true,
  }) =>
      GeneralNewCollectionState(
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        description: description ?? this.description,
        thumbnail: thumbnail ?? this.thumbnail,
        showErrorMessages: showErrorMessages ?? this.showErrorMessages,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        dataFailure: overrideDataFailure
            ? dataFailure
            : (dataFailure ?? this.dataFailure),
      );

  @override
  List<Object> get props => [
        id,
        title,
        subtitle,
        description,
        thumbnail,
        showErrorMessages,
        isSubmitting,
        dataFailure,
      ];
}

class InitialNewCollectionState extends NewCollectionState {
  InitialNewCollectionState()
      : super(
          title: Title(''),
          subtitle: Subtitle(''),
          description: Description(''),
          thumbnail: '',
          showErrorMessages: false,
          isSubmitting: false,
          dataFailure: null,
        );
}

class GeneralNewCollectionState extends NewCollectionState {
  GeneralNewCollectionState({
    Title title,
    Subtitle subtitle,
    Description description,
    String thumbnail,
    bool showErrorMessages,
    bool isSubmitting,
    Either<DataFailure, void> dataFailure,
  }) : super(
          title: title ?? Title(''),
          subtitle: subtitle ?? Subtitle(''),
          description: description ?? Description(''),
          thumbnail: thumbnail ?? '',
          showErrorMessages: showErrorMessages ?? false,
          isSubmitting: isSubmitting ?? false,
          dataFailure: dataFailure ?? null,
        );
}
