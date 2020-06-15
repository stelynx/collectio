import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../util/constant/collectio_theme.dart';
import '../../../../util/constant/language.dart';
import '../../../../util/function/enum_helper/language_enum_helper.dart';
import '../../../../util/function/enum_helper/theme_enum_helper.dart';
import '../../../bloc/settings/edit_settings_bloc.dart';
import '../../../widgets/collectio_dropdown.dart';

class EditSettingsForm extends StatelessWidget {
  const EditSettingsForm();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditSettingsBloc, EditSettingsState>(
      builder: (BuildContext context, EditSettingsState state) => Center(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('App theme'),
              trailing: CollectioDropdown<String>(
                value: ThemeEnumHelper.mapEnumToString(state.theme),
                items: CollectioTheme.values
                    .map((CollectioTheme theme) =>
                        ThemeEnumHelper.mapEnumToString(theme))
                    .toList(),
                onChanged: (String value) => context
                    .bloc<EditSettingsBloc>()
                    .add(ChangeThemeEditSettingsEvent(
                        ThemeEnumHelper.mapStringToEnum(value))),
                isExpanded: false,
              ),
            ),
            ListTile(
              title: Text('Language'),
              trailing: CollectioDropdown<String>(
                value: LanguageEnumHelper.mapEnumToString(state.language),
                items: Language.values
                    .map((Language language) =>
                        LanguageEnumHelper.mapEnumToString(language))
                    .toList(),
                onChanged: (String value) => context
                    .bloc<EditSettingsBloc>()
                    .add(ChangeLanguageEditSettingsEvent(
                        LanguageEnumHelper.mapStringToEnum(value))),
                isExpanded: false,
              ),
            )
          ],
        ),
      ),
    );
  }
}
