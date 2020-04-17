import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/collection.dart';
import '../../../../util/constant/constants.dart';
import '../../../../util/injection/injection.dart';
import '../../../bloc/collections/collections_bloc.dart';
import '../../../widgets/collectio_list.dart';
import '../../shared/error.dart';

class CollectionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My collections'),
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
              onTap: (Collection collection) => print(collection.title),
            );
          }

          return ErrorScreen(message: Constants.unknownStateMessage);
        },
      ),
    );
  }
}
