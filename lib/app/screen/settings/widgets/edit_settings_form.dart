import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../util/constant/collectio_theme.dart';
import '../../../../util/function/enum_helper.dart';
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
                value: describeEnum(state.theme),
                items: CollectioTheme.values
                    .map((CollectioTheme theme) => describeEnum(theme))
                    .toList(),
                hint: 'Pick theme ...',
                onChanged: (String value) => context
                    .bloc<EditSettingsBloc>()
                    .add(ChangeThemeEditSettingsEvent(
                        enumFromString(value, CollectioTheme.values))),
                isExpanded: false,
              ),
            )
          ],
        ),
      ),
    );
  }
}
