import 'dart:io';

import 'package:collectio/platform/image_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../util/constant/constants.dart';
import '../../../../../util/error/data_failure.dart';
import '../../../../../util/error/failure.dart';
import '../../../../bloc/collections/new_collection_bloc.dart';

class NewCollectionForm extends StatelessWidget {
  final ImageSelector _imageSelector;

  const NewCollectionForm({@required ImageSelector imageSelector})
      : _imageSelector = imageSelector;

  void _getImage(
    BuildContext context,
    Future<File> Function() imageGetter,
  ) async {
    final File image = await imageGetter();
    final File croppedImage =
        await _imageSelector.cropThumbnailImage(image.path);
    context
        .bloc<NewCollectionBloc>()
        .add(ImageChangedNewCollectionEvent(croppedImage));
  }

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
            padding: EdgeInsets.all(20),
            children: <Widget>[
              // Image
              AspectRatio(
                aspectRatio: 1 / 1,
                child: GestureDetector(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    builder: (_) => Container(
                      height: 120,
                      child: ListView(
                        children: <Widget>[
                          ListTile(
                            trailing: Icon(Icons.photo_camera),
                            title: Text('Camera'),
                            onTap: () => _getImage(
                              context,
                              _imageSelector.takeImageWithCamera,
                            ),
                          ),
                          ListTile(
                            trailing: Icon(Icons.photo_library),
                            title: Text('Photo library'),
                            onTap: () => _getImage(
                              context,
                              _imageSelector.getImageFromPhotos,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  child: state.thumbnail == null
                      ? Container(
                          decoration: BoxDecoration(border: Border.all()),
                          child: Center(
                            child: Icon(
                              Icons.add_a_photo,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : Image.file(state.thumbnail),
                ),
              ),

              SizedBox(height: 20),

              // Title
              TextField(
                autocorrect: false,
                autofocus: true,
                decoration: InputDecoration(
                    labelText: 'Title',
                    errorText: state.showErrorMessages && !state.title.isValid()
                        ? state.title.value.fold(
                            (ValidationFailure failure) =>
                                failure is TitleEmptyValidationFailure
                                    ? Constants.emptyValidationFailure
                                    : Constants.titleValidationFailure,
                            (_) => null)
                        : null),
                onChanged: (String value) => context
                    .bloc<NewCollectionBloc>()
                    .add(TitleChangedNewCollectionEvent(value)),
              ),

              SizedBox(height: 10),

              // Subtitle
              TextField(
                autocorrect: false,
                decoration: InputDecoration(
                    labelText: 'Subtitle',
                    errorText:
                        state.showErrorMessages && !state.subtitle.isValid()
                            ? state.subtitle.value.fold(
                                (ValidationFailure failure) =>
                                    failure is SubtitleEmptyValidationFailure
                                        ? Constants.emptyValidationFailure
                                        : Constants.subtitleValidationFailure,
                                (_) => null)
                            : null),
                onChanged: (String value) => context
                    .bloc<NewCollectionBloc>()
                    .add(SubtitleChangedNewCollectionEvent(value)),
              ),

              SizedBox(height: 10),

              // Description
              TextField(
                autocorrect: false,
                maxLines: null,
                decoration: InputDecoration(
                    labelText: 'Description',
                    errorText: state.showErrorMessages &&
                            !state.description.isValid()
                        ? state.description.value.fold(
                            (ValidationFailure failure) =>
                                failure is DescriptionEmptyValidationFailure
                                    ? Constants.emptyValidationFailure
                                    : Constants.descriptionValidationFailure,
                            (_) => null)
                        : null),
                onChanged: (String value) => context
                    .bloc<NewCollectionBloc>()
                    .add(DescriptionChangedNewCollectionEvent(value)),
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
                RaisedButton(
                  onPressed: () => context
                      .bloc<NewCollectionBloc>()
                      .add(SubmitNewCollectionEvent()),
                  child: Text('Submit'),
                ),

                // Cancel
                RaisedButton(
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
