import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../util/injection/injection.dart';
import '../../bloc/settings/edit_settings_bloc.dart';
import '../../widgets/collectio_drawer.dart';
import 'widgets/edit_settings_form.dart';

class EditSettingsScreen extends StatelessWidget {
  const EditSettingsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
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
