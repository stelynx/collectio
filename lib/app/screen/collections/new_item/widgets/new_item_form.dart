import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../util/constant/constants.dart';
import '../../../../../util/error/data_failure.dart';
import '../../../../../util/error/validation_failure.dart';
import '../../../../bloc/collections/new_item_bloc.dart';

class NewItemForm extends StatelessWidget {
  const NewItemForm();

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
                    .bloc<NewItemBloc>()
                    .add(TitleChangedNewItemEvent(value)),
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
              DropdownButton(
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
