import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../platform/image_selector.dart';
import '../../../../../util/constant/country.dart';
import '../../../../../util/constant/translation.dart';
import '../../../../../util/function/enum_helper/country_enum_helper.dart';
import '../../../../../util/injection/injection.dart';
import '../../../../bloc/profile/edit_profile_bloc.dart';
import '../../../../bloc/profile/profile_bloc.dart';
import '../../../../config/app_localizations.dart';
import '../../../../theme/style.dart';
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
            padding: CollectioStyle.screenPadding,
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
              CollectioStyle.itemSplitter,
              CollectioStyle.itemSplitter,
              CollectioTextField(
                labelText: AppLocalizations.of(context)
                    .translate(Translation.firstName),
                initialValue: state is InitialEditProfileState
                    ? state.firstName.get()
                    : null,
                onChanged: (String value) => context
                    .bloc<EditProfileBloc>()
                    .add(FirstNameChangedEditProfileEvent(value)),
              ),
              CollectioStyle.itemSplitter,
              CollectioStyle.itemSplitter,
              CollectioTextField(
                labelText: AppLocalizations.of(context)
                    .translate(Translation.lastName),
                initialValue: state is InitialEditProfileState
                    ? state.lastName.get()
                    : null,
                onChanged: (String value) => context
                    .bloc<EditProfileBloc>()
                    .add(LastNameChangedEditProfileEvent(value)),
              ),
              CollectioStyle.itemSplitter,
              CollectioStyle.itemSplitter,
              CollectioDropdown<String>(
                value: state.country != null
                    ? CountryEnumHelper.mapEnumToString(state.country)
                    : null,
                items: Country.values
                    .map((Country country) =>
                        CountryEnumHelper.mapEnumToString(country))
                    .toList(),
                hint:
                    AppLocalizations.of(context).translate(Translation.country),
                onChanged: (String value) => context
                    .bloc<EditProfileBloc>()
                    .add(CountryChangedEditProfileEvent(
                        CountryEnumHelper.mapStringToEnum(value))),
                icon: Icon(Icons.flag),
              ),
              CollectioStyle.itemSplitter,
              CollectioStyle.itemSplitter,
              if (state.isSubmitting) ...[
                Center(child: CircularProgressIndicator()),
              ] else ...[
                CollectioButton(
                  onPressed: () => context
                      .bloc<EditProfileBloc>()
                      .add(SubmitEditProfileEvent()),
                  text:
                      AppLocalizations.of(context).translate(Translation.save),
                  isPrimary: true,
                ),
                CollectioStyle.itemSplitter,
                CollectioButton(
                  onPressed: () => context
                      .bloc<EditProfileBloc>()
                      .add(ResetEditProfileEvent()),
                  text:
                      AppLocalizations.of(context).translate(Translation.reset),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
