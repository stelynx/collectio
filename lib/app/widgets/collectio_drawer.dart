import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../util/constant/translation.dart';
import '../../util/injection/injection.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/profile/profile_bloc.dart';
import '../config/app_localizations.dart';
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
                    title: Text(
                        '${AppLocalizations.of(context).translate(Translation.hello)}, ${state.userProfile.username}'),
                    subtitle: Row(
                      children: <Widget>[
                        CollectioLink(
                          text: AppLocalizations.of(context)
                              .translate(Translation.viewProfile),
                          onTap: () => Navigator.of(context).pushNamed(
                            Routes.profile,
                            arguments: state.userProfile,
                          ),
                        ),
                        SizedBox(width: 10),
                        CollectioLink(
                          text: AppLocalizations.of(context)
                              .translate(Translation.editProfile),
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
                    Text(AppLocalizations.of(context)
                        .translate(Translation.loadingProfile)),
                    CircularProgressIndicator(),
                  ],
                );
              },
            ),
            Divider(),
            ListTile(
              dense: true,
              title: Text(AppLocalizations.of(context)
                  .translate(Translation.titleSettings)),
              trailing: Icon(Icons.settings),
              onTap: () {
                Navigator.of(context).pushNamed(Routes.settings);
              },
            ),
            ListTile(
              dense: true,
              title: Text(
                  AppLocalizations.of(context).translate(Translation.logout)),
              trailing: Icon(Icons.exit_to_app),
              onTap: () {
                context.bloc<AuthBloc>().add(SignedOutAuthEvent());
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(Routes.signIn, (route) => false);
              },
            ),
            Spacer(),
            Text(AppLocalizations.of(context).translate(Translation.copyright)),
          ],
        ),
      ),
    );
  }
}
