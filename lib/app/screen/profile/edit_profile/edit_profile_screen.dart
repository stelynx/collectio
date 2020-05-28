import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../util/injection/injection.dart';
import '../../../bloc/profile/edit_profile_bloc.dart';
import '../../../widgets/collectio_drawer.dart';
import 'widget/edit_profile_form.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditProfileBloc>(
      create: (BuildContext context) => getIt<EditProfileBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit profile'),
        ),
        endDrawer: CollectioDrawer(),
        body: EditProfileForm(),
      ),
    );
  }
}
