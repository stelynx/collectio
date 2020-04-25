import 'package:collectio/app/bloc/collections/new_collection_bloc.dart';
import 'package:collectio/util/constant/constants.dart';
import 'package:collectio/util/error/data_failure.dart';
import 'package:collectio/util/error/failure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewCollectionForm extends StatelessWidget {
  const NewCollectionForm();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewCollectionBloc, NewCollectionState>(
      listener: (BuildContext context, NewCollectionState state) {
        if (state.dataFailure.isRight()) {
          Navigator.of(context).pop();
        }
      },
      builder: (BuildContext context, NewCollectionState state) {
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
          ),
        );
      },
    );
  }
}
