import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/collection.dart';
import '../../../../util/constant/constants.dart';
import '../../../../util/injection/injection.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/collections/collections_bloc.dart';
import '../../../routes/routes.dart';
import '../../../widgets/collectio_list.dart';
import '../../shared/error.dart';

class CollectionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My collections'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                getIt<AuthBloc>().add(SignedOutAuthEvent());
                Navigator.of(context).pushNamedAndRemoveUntil(
                    Routes.signIn, (Route route) => false);
              })
        ],
      ),
      body: BlocBuilder<CollectionsBloc, CollectionsState>(
        bloc: getIt<CollectionsBloc>(),
        builder: (BuildContext context, CollectionsState state) {
          if (state is InitialCollectionsState ||
              state is LoadingCollectionsState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is LoadedCollectionsState) {
            return CollectioList(
              items: state.collections,
              onTap: (Collection collection) => Navigator.of(context)
                  .pushNamed(Routes.collection, arguments: collection),
              onDismiss: (Collection collection) => getIt<CollectionsBloc>()
                  .add(DeleteCollectionCollectionsEvent(collection)),
              fullScreen: true,
            );
          }

          if (state is ErrorCollectionsState) {
            return ErrorScreen(message: 'Error occured');
          }

          return ErrorScreen(message: Constants.unknownStateMessage);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(Routes.newCollection),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
