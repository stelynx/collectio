import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../platform/image_selector.dart';
import '../../../../../util/constant/country.dart';
import '../../../../../util/function/enum_helper.dart';
import '../../../../../util/injection/injection.dart';
import '../../../../bloc/profile/edit_profile_bloc.dart';
import '../../../../bloc/profile/profile_bloc.dart';
import '../../../../widgets/collectio_button.dart';
import '../../../../widgets/collectio_dropdown.dart';
import '../../../../widgets/collectio_image_picker.dart';
import '../../../../widgets/collectio_text_field.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileBloc, EditProfileState>(
      listener: (BuildContext context, EditProfileState state) {
        if (state.dataFailure != null && state.dataFailure.isRight()) {
          getIt<ProfileBloc>().add(GetUserProfileEvent());
          Navigator.of(context).pop();
        }
      },
      builder: (BuildContext context, EditProfileState state) {
        return Center(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              CollectioImagePicker(
                imageSelector: getIt<ImageSelector>(),
                parentContext: context,
                aspectRatio: 1 / 1,
                croppedImageHandler: (File photo) => context
                    .bloc<EditProfileBloc>()
                    .add(ImageChangedEditProfileEvent(photo)),
                thumbnail: state.profileImage?.get(),
                isImageLocal: state.profileImage?.get() != null ||
                    state.oldImageUrl == null,
                url: state.profileImage?.get() == null
                    ? state.oldImageUrl
                    : null,
              ),
              SizedBox(height: 20),
              CollectioTextField(
                labelText: 'First name',
                initialValue: state is InitialEditProfileState
                    ? state.firstName.get()
                    : null,
                onChanged: (String value) => context
                    .bloc<EditProfileBloc>()
                    .add(FirstNameChangedEditProfileEvent(value)),
              ),
              SizedBox(height: 20),
              CollectioTextField(
                labelText: 'Last name',
                initialValue: state is InitialEditProfileState
                    ? state.lastName.get()
                    : null,
                onChanged: (String value) => context
                    .bloc<EditProfileBloc>()
                    .add(LastNameChangedEditProfileEvent(value)),
              ),
              SizedBox(height: 20),
              CollectioDropdown<String>(
                value: describeEnum(state.country),
                items: Country.values
                    .map((Country country) => describeEnum(country))
                    .toList(),
                hint: 'Country',
                onChanged: (String country) => context
                    .bloc<EditProfileBloc>()
                    .add(CountryChangedEditProfileEvent(
                        enumFromString(country, Country.values))),
                icon: Icon(Icons.flag),
              ),
              SizedBox(height: 20),
              if (state.isSubmitting) ...[
                Center(child: CircularProgressIndicator()),
              ] else ...[
                CollectioButton(
                  onPressed: () => context
                      .bloc<EditProfileBloc>()
                      .add(SubmitEditProfileEvent()),
                  child: Text('Save'),
                ),
                SizedBox(height: 10),
                CollectioButton(
                  onPressed: () => context
                      .bloc<EditProfileBloc>()
                      .add(ResetEditProfileEvent()),
                  child: Text('Reset'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
