import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../util/constant/translation.dart';
import '../../../util/injection/injection.dart';
import '../../bloc/settings/edit_settings_bloc.dart';
import '../../config/app_localizations.dart';
import '../../widgets/collectio_drawer.dart';
import 'widgets/edit_settings_form.dart';

class EditSettingsScreen extends StatelessWidget {
  const EditSettingsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context).translate(Translation.titleSettings)),
      ),
      endDrawer: CollectioDrawer(),
      body: SafeArea(
        child: BlocProvider<EditSettingsBloc>(
          create: (BuildContext context) => getIt<EditSettingsBloc>(),
          child: EditSettingsForm(),
        ),
      ),
    );
  }
}
