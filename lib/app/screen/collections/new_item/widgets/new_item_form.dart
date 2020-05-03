import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../platform/image_selector.dart';
import '../../../../../util/constant/constants.dart';
import '../../../../../util/error/data_failure.dart';
import '../../../../../util/error/validation_failure.dart';
import '../../../../../util/injection/injection.dart';
import '../../../../bloc/collections/new_item_bloc.dart';

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
        print('title ${state.title.get()}');
        print('subtitle ${state.subtitle.get()}');
        print('desc ${state.description.get()}');
        print('raiting ${state.raiting}');
        print('img ${state.localImage?.path}');
        return Center(
          child: ListView(
            padding: EdgeInsets.all(20),
            children: <Widget>[
              AspectRatio(
                aspectRatio: 16 / 9,
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
                  child: state.localImage == null
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
                      : Image.file(state.localImage),
                ),
              ),

              SizedBox(height: 20),

              // Title
              TextField(
                autocorrect: false,
                decoration: InputDecoration(
                    labelText: 'Title',
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 17, vertical: 15),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    errorText: state.showErrorMessages && !state.title.isValid()
                        ? state.title.value.fold(
                            (ValidationFailure failure) =>
                                failure is TitleEmptyValidationFailure
                                    ? Constants.emptyValidationFailure
                                    : Constants.titleValidationFailure,
                            (_) => null)
                        : null),
                onChanged: (String value) => context
                    .bloc<NewItemBloc>()
                    .add(TitleChangedNewItemEvent(value)),
              ),

              SizedBox(height: 10),

              // Subtitle
              TextField(
                autocorrect: false,
                decoration: InputDecoration(
                    labelText: 'Subtitle',
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 17, vertical: 15),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
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
                    .bloc<NewItemBloc>()
                    .add(SubtitleChangedNewItemEvent(value)),
              ),

              SizedBox(height: 10),

              // Description
              TextField(
                autocorrect: false,
                maxLines: null,
                decoration: InputDecoration(
                    labelText: 'Description',
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 17, vertical: 15),
                    enabledBorder: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
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
                    .bloc<NewItemBloc>()
                    .add(DescriptionChangedNewItemEvent(value)),
              ),

              SizedBox(height: 10),

              // Raiting
              DropdownButtonHideUnderline(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: DropdownButton(
                    icon: Icon(Icons.grade),
                    isDense: true,
                    isExpanded: true,
                    value: state.raiting,
                    items: (List<int>.generate(10, (int i) => i + 1))
                        .map(
                          (int i) => DropdownMenuItem(
                            child: Text(i.toString()),
                            value: i,
                          ),
                        )
                        .toList(),
                    onChanged: (int value) => context
                        .bloc<NewItemBloc>()
                        .add(RaitingChangedNewItemEvent(value)),
                    hint: Text('Raiting'),
                  ),
                ),
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
                  onPressed: () =>
                      context.bloc<NewItemBloc>().add(SubmitNewItemEvent()),
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
