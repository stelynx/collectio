import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../model/collection.dart';
import '../../../../../model/image_metadata.dart';
import '../../../../../platform/image_selector.dart';
import '../../../../../util/constant/translation.dart';
import '../../../../../util/error/data_failure.dart';
import '../../../../../util/error/validation_failure.dart';
import '../../../../../util/injection/injection.dart';
import '../../../../bloc/collections/new_item_bloc.dart';
import '../../../../config/app_localizations.dart';
import '../../../../theme/style.dart';
import '../../../../widgets/collectio_button.dart';
import '../../../../widgets/collectio_dropdown.dart';
import '../../../../widgets/collectio_image_picker.dart';
import '../../../../widgets/collectio_text_field.dart';
import '../../../../widgets/collectio_typeahead_field.dart';
import '../../../../widgets/failure_text.dart';

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
                croppedImageHandler: ({
                  @required File image,
                  @required ImageMetadata metadata,
                }) =>
                    context.bloc<NewItemBloc>().add(ImageChangedNewItemEvent(
                          image: image,
                          metadata: metadata,
                        )),
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
                        (ValidationFailure failure) => failure
                                is TitleEmptyValidationFailure
                            ? AppLocalizations.of(context)
                                .translate(Translation.emptyValidationFailure)
                            : AppLocalizations.of(context)
                                .translate(Translation.titleValidationFailure),
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
                            AppLocalizations.of(context)
                                .translate(Translation.emptyValidationFailure),
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
                errorText: state.showErrorMessages &&
                        !state.description.isValid()
                    ? state.description.value.fold(
                        (ValidationFailure failure) => failure
                                is DescriptionEmptyValidationFailure
                            ? AppLocalizations.of(context)
                                .translate(Translation.emptyValidationFailure)
                            : AppLocalizations.of(context).translate(
                                Translation.descriptionValidationFailure),
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
                hint:
                    AppLocalizations.of(context).translate(Translation.raiting),
                icon: Icons.star,
                onChanged: (int value) => context
                    .bloc<NewItemBloc>()
                    .add(RaitingChangedNewItemEvent(value)),
              ),

              CollectioStyle.itemSplitter,

              // Location
              CollectioTypeAheadField(
                text: state.location,
                icon: Icons.location_on,
                suggestionsCallback:
                    context.bloc<NewItemBloc>().getLocationSuggestions,
                onSuggestionSelected: (String value) => context
                    .bloc<NewItemBloc>()
                    .add(LocationChangedNewItemEvent(value)),
              ),

              CollectioStyle.itemSplitter,

              if (state.dataFailure != null && state.dataFailure.isLeft()) ...[
                state.dataFailure.fold(
                    (DataFailure failure) => FailureText(failure.message),
                    null),
              ],

              if (state.isSubmitting) ...[
                Center(child: CircularProgressIndicator()),
              ] else ...[
                // Submit
                CollectioButton(
                  onPressed: () =>
                      context.bloc<NewItemBloc>().add(SubmitNewItemEvent()),
                  text: AppLocalizations.of(context)
                      .translate(Translation.submit),
                  isPrimary: true,
                ),

                CollectioStyle.itemSplitter,

                // Cancel
                CollectioButton(
                  onPressed: () => Navigator.of(context).pop(),
                  text: AppLocalizations.of(context)
                      .translate(Translation.cancel),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
