part of 'new_item_bloc.dart';

abstract class NewItemState extends Equatable {
  final String owner;
  final String collectionName;

  final Title title;
  final Subtitle subtitle;
  final Description description;
  final int raiting;
  final String imageUrl;
  final Photo localImage;
  final bool isSubmitting;
  final bool showErrorMessages;
  final Either<DataFailure, void> dataFailure;

  NewItemState({
    @required this.owner,
    @required this.collectionName,
    @required this.title,
    @required this.subtitle,
    @required this.description,
    @required this.raiting,
    @required this.imageUrl,
    @required this.localImage,
    @required this.isSubmitting,
    @required this.showErrorMessages,
    @required this.dataFailure,
  });

  NewItemState copyWith({
    String owner,
    String collectionName,
    Title title,
    Subtitle subtitle,
    Description description,
    int raiting,
    String imageUrl,
    Photo localImage,
    bool isSubmitting,
    bool showErrorMessages,
    Either<DataFailure, void> dataFailure,
    bool overrideDataFailure = false,
  }) =>
      GeneralNewItemState(
        owner: owner ?? this.owner,
        collectionName: collectionName ?? this.collectionName,
        title: title ?? this.title,
        subtitle: subtitle ?? this.subtitle,
        description: description ?? this.description,
        raiting: raiting ?? this.raiting,
        imageUrl: imageUrl ?? this.imageUrl,
        localImage: localImage ?? this.localImage,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        showErrorMessages: showErrorMessages ?? this.showErrorMessages,
        dataFailure: (dataFailure != null || overrideDataFailure == true)
            ? dataFailure
            : this.dataFailure,
      );

  @override
  List<Object> get props => [
        owner,
        collectionName,
        title,
        subtitle,
        description,
        raiting,
        imageUrl,
        localImage,
        isSubmitting,
        showErrorMessages,
        dataFailure
      ];
}

class InitialNewItemState extends NewItemState {
  InitialNewItemState()
      : super(
            owner: null,
            collectionName: null,
            title: Title(''),
            subtitle: Subtitle(''),
            description: Description(''),
            raiting: null,
            imageUrl: '',
            localImage: Photo(null),
            isSubmitting: false,
            showErrorMessages: false,
            dataFailure: null);
}

class GeneralNewItemState extends NewItemState {
  GeneralNewItemState({
    String owner,
    String collectionName,
    Title title,
    Subtitle subtitle,
    Description description,
    int raiting,
    String imageUrl,
    Photo localImage,
    bool isSubmitting,
    bool showErrorMessages,
    Either<DataFailure, void> dataFailure,
  }) : super(
          owner: owner,
          collectionName: collectionName,
          title: title ?? Title(''),
          subtitle: subtitle ?? Subtitle(''),
          description: description ?? Description(''),
          raiting: raiting,
          imageUrl: imageUrl ?? '',
          localImage: localImage ?? Photo(null),
          isSubmitting: isSubmitting ?? false,
          showErrorMessages: showErrorMessages ?? false,
          dataFailure: dataFailure ?? null,
        );
}
