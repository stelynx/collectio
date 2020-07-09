part of 'new_collection_bloc.dart';

@immutable
abstract class NewCollectionState extends Equatable {
  final String id;
  final Title title;
  final Subtitle subtitle;
  final Description description;
  final Photo thumbnail;
  final bool isPremium;
  final Name itemTitleName;
  final Name itemSubtitleName;
  final Name itemDescriptionName;
  final bool showErrorMessages;
  final bool isSubmitting;
  final Either<DataFailure, void> dataFailure;

  NewCollectionState({
    @required this.title,
    @required this.subtitle,
    @required this.description,
    @required this.thumbnail,
    @required this.isPremium,
    @required this.itemTitleName,
    @required this.itemSubtitleName,
    @required this.itemDescriptionName,
    @required this.showErrorMessages,
    @required this.isSubmitting,
    @required this.dataFailure,
  }) : id = getId(title.get());

  NewCollectionState copyWith({
    Title title,
    Subtitle subtitle,
    Description description,
    Photo thumbnail,
    bool isPremium,
    Name itemTitleName,
    Name itemSubtitleName,
    Name itemDescriptionName,
    bool showErrorMessages,
    bool isSubmitting,
    Either<DataFailure, void> dataFailure,
    bool overrideDataFailure = false,
  }) =>
      GeneralNewCollectionState(
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        description: description ?? this.description,
        thumbnail: thumbnail ?? this.thumbnail,
        isPremium: isPremium ?? this.isPremium,
        itemTitleName: itemTitleName ?? this.itemTitleName,
        itemSubtitleName: itemSubtitleName ?? this.itemSubtitleName,
        itemDescriptionName: itemDescriptionName ?? this.itemDescriptionName,
        showErrorMessages: showErrorMessages ?? this.showErrorMessages,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        dataFailure: (dataFailure != null || overrideDataFailure == true)
            ? dataFailure
            : this.dataFailure,
      );

  @override
  List<Object> get props => [
        id,
        title,
        subtitle,
        description,
        isPremium,
        itemTitleName,
        itemSubtitleName,
        itemDescriptionName,
        showErrorMessages,
        isSubmitting,
        dataFailure,
        thumbnail,
      ];
}

class InitialNewCollectionState extends NewCollectionState {
  InitialNewCollectionState()
      : super(
          title: Title(''),
          subtitle: Subtitle(''),
          description: Description(''),
          thumbnail: Photo(null),
          isPremium: false,
          itemTitleName: Name('Title'),
          itemSubtitleName: Name('Subtitle'),
          itemDescriptionName: Name('Description'),
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
    Photo thumbnail,
    bool isPremium,
    Name itemTitleName,
    Name itemSubtitleName,
    Name itemDescriptionName,
    bool showErrorMessages,
    bool isSubmitting,
    Either<DataFailure, void> dataFailure,
  }) : super(
          title: title ?? Title(''),
          subtitle: subtitle ?? Subtitle(''),
          description: description ?? Description(''),
          thumbnail: thumbnail ?? Photo(null),
          isPremium: isPremium ?? false,
          itemTitleName: itemTitleName ?? Name('Title'),
          itemSubtitleName: itemSubtitleName ?? Name('Subtitle'),
          itemDescriptionName: itemDescriptionName ?? Name('Description'),
          showErrorMessages: showErrorMessages ?? false,
          isSubmitting: isSubmitting ?? false,
          dataFailure: dataFailure ?? null,
        );
}
