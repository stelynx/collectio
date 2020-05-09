import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../platform/image_selector.dart';
import '../../../../../util/constant/constants.dart';
import '../../../../../util/error/data_failure.dart';
import '../../../../../util/error/validation_failure.dart';
import '../../../../../util/injection/injection.dart';
import '../../../../bloc/collections/new_item_bloc.dart';
import '../../../../widgets/collectio_button.dart';
import '../../../../widgets/collectio_dropdown.dart';
import '../../../../widgets/collectio_image_picker.dart';
import '../../../../widgets/collectio_text_field.dart';

class NewItemForm extends StatelessWidget {
  final ImageSelector _imageSelector;

  const NewItemForm({@required ImageSelector imageSelector})
      : _imageSelector = imageSelector;

  void _getImage(
    BuildContext context,
    Future<File> Function() imageGetter,
  ) async {
    final File image = await imageGetter();
    final File croppedImage = await _imageSelector.cropItemImage(image.path);
    context.bloc<NewItemBloc>().add(ImageChangedNewItemEvent(croppedImage));
  }

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
            padding: EdgeInsets.all(20),
            children: <Widget>[
              //Image
              CollectioImagePicker(
                imageSelector: getIt<ImageSelector>(),
                parentContext: context,
                aspectRatio: 16 / 9,
                thumbnail: state.localImage,
                croppedImageHandler: (File croppedImage) => context
                    .bloc<NewItemBloc>()
                    .add(ImageChangedNewItemEvent(croppedImage)),
              ),

              SizedBox(height: 20),

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
                    .bloc<NewItemBloc>()
                    .add(TitleChangedNewItemEvent(value)),
              ),

              SizedBox(height: 10),

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
                    .bloc<NewItemBloc>()
                    .add(SubtitleChangedNewItemEvent(value)),
              ),

              SizedBox(height: 10),

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
                    .bloc<NewItemBloc>()
                    .add(DescriptionChangedNewItemEvent(value)),
              ),

              SizedBox(height: 10),

              // Raiting
              CollectioDropdown<int>(
                value: state.raiting,
                items: List<int>.generate(10, (int i) => i + 1),
                hint: 'Raiting',
                onChanged: (int value) => context
                    .bloc<NewItemBloc>()
                    .add(RaitingChangedNewItemEvent(value)),
              ),

              SizedBox(height: 10),

              if (state.dataFailure != null && state.dataFailure.isLeft()) ...[
                state.dataFailure.fold(
                    (DataFailure failure) => Text(
                          failure.message,
                          style: TextStyle(color: Colors.red),
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
