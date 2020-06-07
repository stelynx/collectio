import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/settings.dart';
import '../../../../util/constant/collectio_theme.dart';
import '../../../../util/function/enum_helper.dart';
import '../../../bloc/settings/edit_settings_bloc.dart';
import '../../../widgets/collectio_dropdown.dart';

class EditSettingsForm extends StatelessWidget {
  final Settings settings;

  const EditSettingsForm({@required this.settings});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text('App theme'),
            trailing: CollectioDropdown<String>(
              value:
                  settings.theme != null ? describeEnum(settings.theme) : null,
              items: CollectioTheme.values
                  .map((CollectioTheme theme) => describeEnum(theme))
                  .toList(),
              hint: 'Pick theme ...',
              onChanged: (String value) => context.bloc<EditSettingsBloc>().add(
                  ChangeThemeEditSettingsEvent(
                      enumFromString(value, CollectioTheme.values))),
              isExpanded: false,
            ),
          )
        ],
      ),
    );
  }
}
