import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../util/injection/injection.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/profile/profile_bloc.dart';
import '../routes/routes.dart';
import 'circular_network_image.dart';
import 'collectio_link.dart';

class CollectioDrawer extends StatelessWidget {
  const CollectioDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            BlocBuilder<ProfileBloc, ProfileState>(
              bloc: getIt<ProfileBloc>(),
              builder: (BuildContext context, ProfileState state) {
                if (state is CompleteProfileState)
                  return ListTile(
                    title: Text('Hi, ${state.userProfile.username}'),
                    subtitle: Row(
                      children: <Widget>[
                        CollectioLink(
                          text: 'View profile',
                          onTap: () => Navigator.of(context).pushNamed(
                            Routes.profile,
                            arguments: state.userProfile,
                          ),
                        ),
                        SizedBox(width: 10),
                        CollectioLink(
                          text: 'Edit profile',
                          onTap: () => Navigator.of(context).pushNamed(
                            Routes.editProfile,
                          ),
                        ),
                      ],
                    ),
                    leading: CircularNetworkImage(
                      state.userProfile.profileImg,
                      radius: 20,
                    ),
                  );

                return Row(
                  children: <Widget>[
                    Text('Retrieving profile data ...'),
                    CircularProgressIndicator(),
                  ],
                );
              },
            ),
            Divider(),
            ListTile(
              dense: true,
              title: Text('Settings'),
              trailing: Icon(Icons.settings),
              onTap: () {
                Navigator.of(context).pushNamed(Routes.settings);
              },
            ),
            ListTile(
              dense: true,
              title: Text('Logout'),
              trailing: Icon(Icons.exit_to_app),
              onTap: () {
                context.bloc<AuthBloc>().add(SignedOutAuthEvent());
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(Routes.signIn, (route) => false);
              },
            ),
            Spacer(),
            Text('Copyright Stelynx, 2020'),
          ],
        ),
      ),
    );
  }
}
