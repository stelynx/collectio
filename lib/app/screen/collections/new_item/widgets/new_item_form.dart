import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../model/collection.dart';
import '../../../../../platform/image_selector.dart';
import '../../../../../util/constant/constants.dart';
import '../../../../../util/error/data_failure.dart';
import '../../../../../util/error/validation_failure.dart';
import '../../../../../util/injection/injection.dart';
import '../../../../bloc/collections/new_item_bloc.dart';
import '../../../../theme/style.dart';
import '../../../../widgets/collectio_button.dart';
import '../../../../widgets/collectio_dropdown.dart';
import '../../../../widgets/collectio_image_picker.dart';
import '../../../../widgets/collectio_text_field.dart';

class NewItemForm extends StatelessWidget {
  final Collection collection;

  const NewItemForm({@required this.collection});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewItemBloc, NewItemState>(
      listener: (BuildContext context, NewItemState state) {
        if (state.dataFailure != null && state.dataFailure.isRight()) {
          Navigator.of(context).pop();
        }
      },
      builder: (BuildContext context, NewItemState state) {
        return Center(
          child: ListView(
            padding: CollectioStyle.screenPadding,
            children: <Widget>[
              //Image
              CollectioImagePicker(
                imageSelector: getIt<ImageSelector>(),
                parentContext: context,
                aspectRatio: 16 / 9,
                thumbnail: state.localImage.get(),
                croppedImageHandler: (File croppedImage) => context
                    .bloc<NewItemBloc>()
                    .add(ImageChangedNewItemEvent(croppedImage)),
                showError:
                    state.showErrorMessages && !state.localImage.isValid(),
              ),

              CollectioStyle.itemSplitter,
              CollectioStyle.itemSplitter,

              // Title
              CollectioTextField(
                labelText: collection.itemTitleName,
                errorText: state.showErrorMessages && !state.title.isValid()
                    ? state.title.value.fold(
                        (ValidationFailure failure) =>
                            failure is TitleEmptyValidationFailure
                                ? Constants.emptyValidationFailure
                                : Constants.titleValidationFailure,
                        (_) => null)
                    : null,
                onChanged: (String value) => context
                    .bloc<NewItemBloc>()
                    .add(TitleChangedNewItemEvent(value)),
              ),

              CollectioStyle.itemSplitter,

              // Subtitle
              CollectioTextField(
                labelText: collection.itemSubtitleName,
                errorText: state.showErrorMessages && !state.subtitle.isValid()
                    ? state.subtitle.value.fold(
                        (ValidationFailure failure) =>
                            failure is SubtitleEmptyValidationFailure
                                ? Constants.emptyValidationFailure
                                : Constants.subtitleValidationFailure,
                        (_) => null)
                    : null,
                onChanged: (String value) => context
                    .bloc<NewItemBloc>()
                    .add(SubtitleChangedNewItemEvent(value)),
              ),

              CollectioStyle.itemSplitter,

              // Description
              CollectioTextField(
                maxLines: null,
                labelText: collection.itemDescriptionName,
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
                    .bloc<NewItemBloc>()
                    .add(DescriptionChangedNewItemEvent(value)),
              ),

              CollectioStyle.itemSplitter,

              // Raiting
              CollectioDropdown<int>(
                value: state.raiting,
                items: List<int>.generate(10, (int i) => i + 1),
                hint: 'Raiting',
                icon: Icon(Icons.star),
                onChanged: (int value) => context
                    .bloc<NewItemBloc>()
                    .add(RaitingChangedNewItemEvent(value)),
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
                  onPressed: () =>
                      context.bloc<NewItemBloc>().add(SubmitNewItemEvent()),
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
