import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../platform/image_selector.dart';
import '../../../../../util/constant/constants.dart';
import '../../../../../util/error/data_failure.dart';
import '../../../../../util/error/failure.dart';
import '../../../../../util/injection/injection.dart';
import '../../../../bloc/collections/new_collection_bloc.dart';
import '../../../../theme/style.dart';
import '../../../../widgets/collectio_button.dart';
import '../../../../widgets/collectio_image_picker.dart';
import '../../../../widgets/collectio_section_title.dart';
import '../../../../widgets/collectio_text_field.dart';

class NewCollectionForm extends StatelessWidget {
  const NewCollectionForm();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewCollectionBloc, NewCollectionState>(
      listener: (BuildContext context, NewCollectionState state) {
        if (state.dataFailure != null && state.dataFailure.isRight()) {
          Navigator.of(context).pop();
        }
      },
      builder: (BuildContext context, NewCollectionState state) {
        return Center(
          child: ListView(
            padding: CollectioStyle.screenPadding,
            children: <Widget>[
              // Image
              CollectioImagePicker(
                imageSelector: getIt<ImageSelector>(),
                parentContext: context,
                aspectRatio: 1 / 1,
                thumbnail: state.thumbnail.get(),
                croppedImageHandler: (File croppedImage) => context
                    .bloc<NewCollectionBloc>()
                    .add(ImageChangedNewCollectionEvent(croppedImage)),
                showError:
                    state.showErrorMessages && !state.thumbnail.isValid(),
              ),

              CollectioStyle.itemSplitter,
              CollectioStyle.itemSplitter,

              // Title
              CollectioTextField(
                labelText: 'Title',
                errorText: state.showErrorMessages && !state.title.isValid()
                    ? state.title.value.fold(
                        (ValidationFailure failure) =>
                            failure is TitleEmptyValidationFailure
                                ? Constants.emptyValidationFailure
                                : Constants.titleValidationFailure,
                        (_) => null)
                    : null,
                onChanged: (String value) => context
                    .bloc<NewCollectionBloc>()
                    .add(TitleChangedNewCollectionEvent(value)),
              ),

              CollectioStyle.itemSplitter,

              // Subtitle
              CollectioTextField(
                labelText: 'Subtitle',
                errorText: state.showErrorMessages && !state.subtitle.isValid()
                    ? state.subtitle.value.fold(
                        (ValidationFailure failure) =>
                            failure is SubtitleEmptyValidationFailure
                                ? Constants.emptyValidationFailure
                                : Constants.subtitleValidationFailure,
                        (_) => null)
                    : null,
                onChanged: (String value) => context
                    .bloc<NewCollectionBloc>()
                    .add(SubtitleChangedNewCollectionEvent(value)),
              ),

              CollectioStyle.itemSplitter,

              // Description
              CollectioTextField(
                maxLines: null,
                labelText: 'Description',
                errorText:
                    state.showErrorMessages && !state.description.isValid()
                        ? state.description.value.fold(
                            (ValidationFailure failure) =>
                                failure is DescriptionEmptyValidationFailure
                                    ? Constants.emptyValidationFailure
                                    : Constants.descriptionValidationFailure,
                            (_) => null)
                        : null,
                onChanged: (String value) => context
                    .bloc<NewCollectionBloc>()
                    .add(DescriptionChangedNewCollectionEvent(value)),
              ),

              CollectioSectionTitle(
                'Field names',
                parentHasPadding: true,
              ),

              CollectioTextField(
                labelText: 'Title name',
                initialValue: state is InitialNewCollectionState
                    ? state.itemTitleName.get()
                    : null,
                errorText:
                    state.showErrorMessages && !state.itemTitleName.isValid()
                        ? state.itemTitleName.value.fold(
                            (ValidationFailure failure) =>
                                Constants.emptyValidationFailure,
                            (_) => null)
                        : null,
                onChanged: (String value) => context
                    .bloc<NewCollectionBloc>()
                    .add(ItemTitleNameChangedNewCollectionEvent(value)),
              ),

              CollectioStyle.itemSplitter,

              CollectioTextField(
                labelText: 'Subtitle name',
                initialValue: state is InitialNewCollectionState
                    ? state.itemSubtitleName.get()
                    : null,
                errorText:
                    state.showErrorMessages && !state.itemSubtitleName.isValid()
                        ? state.itemSubtitleName.value.fold(
                            (ValidationFailure failure) =>
                                Constants.emptyValidationFailure,
                            (_) => null)
                        : null,
                onChanged: (String value) => context
                    .bloc<NewCollectionBloc>()
                    .add(ItemSubtitleNameChangedNewCollectionEvent(value)),
              ),

              CollectioStyle.itemSplitter,

              CollectioTextField(
                labelText: 'Description name',
                initialValue: state is InitialNewCollectionState
                    ? state.itemDescriptionName.get()
                    : null,
                errorText: state.showErrorMessages &&
                        !state.itemDescriptionName.isValid()
                    ? state.itemDescriptionName.value.fold(
                        (ValidationFailure failure) =>
                            Constants.emptyValidationFailure,
                        (_) => null)
                    : null,
                onChanged: (String value) => context
                    .bloc<NewCollectionBloc>()
                    .add(ItemDescriptionNameChangedNewCollectionEvent(value)),
              ),

              CollectioStyle.itemSplitter,

              if (state.dataFailure != null && state.dataFailure.isLeft()) ...[
                state.dataFailure.fold(
                    (DataFailure failure) => Text(
                          failure.message,
                          style: TextStyle(color: Theme.of(context).errorColor),
                        ),
                    null),
              ],

              if (state.isSubmitting) ...[
                Center(child: CircularProgressIndicator()),
              ] else ...[
                // Submit
                CollectioButton(
                  onPressed: () => context
                      .bloc<NewCollectionBloc>()
                      .add(SubmitNewCollectionEvent()),
                  child: Text('Submit'),
                ),

                // Cancel
                CollectioButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
