import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/collection.dart';
import '../../../../model/user_profile.dart';
import '../../../../util/constant/translation.dart';
import '../../../../util/function/enum_helper/country_enum_helper.dart';
import '../../../../util/injection/injection.dart';
import '../../../bloc/collections/collections_bloc.dart';
import '../../../config/app_localizations.dart';
import '../../../routes/routes.dart';
import '../../../theme/style.dart';
import '../../../widgets/circular_network_image.dart';
import '../../../widgets/collectio_drawer.dart';
import '../../../widgets/collectio_list.dart';
import '../../../widgets/collectio_section_title.dart';

class ViewProfileScreen extends StatelessWidget {
  final UserProfile profile;

  const ViewProfileScreen(this.profile);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(profile.username),
      ),
      endDrawer: CollectioDrawer(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Card(
              child: Padding(
                padding: CollectioStyle.screenPadding,
                child: Column(
                  children: <Widget>[
                    CircularNetworkImage(profile.profileImg, radius: 50),
                    CollectioStyle.itemSplitter,
                    Column(
                      children: <Widget>[
                        Text('${profile.firstName} ${profile.lastName}'),
                        Text('@${profile.username}'),
                        CollectioStyle.itemSplitter,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.location_on),
                            Text(profile.country != null
                                ? CountryEnumHelper.mapEnumToString(
                                    profile.country)
                                : AppLocalizations.of(context)
                                    .translate(Translation.unknown)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            CollectioSectionTitle(AppLocalizations.of(context)
                .translate(Translation.collections)),
            BlocBuilder<CollectionsBloc, CollectionsState>(
              bloc: getIt<CollectionsBloc>(),
              builder: (BuildContext context, CollectionsState state) {
                if (state is LoadedCollectionsState) {
                  return CollectioList(
                    items: state.collections,
                    onTap: (Collection collection) => Navigator.of(context)
                        .pushNamed(Routes.collection, arguments: collection),
                  );
                }

                return Center(
                  child: Column(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      const SizedBox(height: 5),
                      Text(AppLocalizations.of(context)
                          .translate(Translation.loadingCollections)),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
