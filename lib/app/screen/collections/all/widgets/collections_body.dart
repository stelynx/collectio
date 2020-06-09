import 'package:flutter/material.dart';

import '../../../../../model/collection.dart';
import '../../../../../util/constant/constants.dart';
import '../../../../../util/injection/injection.dart';
import '../../../../bloc/collections/collections_bloc.dart';
import '../../../../routes/routes.dart';
import '../../../../widgets/collectio_list.dart';
import '../../../shared/error.dart';

class CollectionsBody extends StatelessWidget {
  final CollectionsState _state;

  const CollectionsBody({@required CollectionsState collectionsState})
      : _state = collectionsState;

  @override
  Widget build(BuildContext context) {
    if (_state is InitialCollectionsState || _state is LoadingCollectionsState)
      return Center(
        child: CircularProgressIndicator(),
      );
    if (_state is LoadedCollectionsState)
      return CollectioList(
        items: (_state as LoadedCollectionsState).displayedCollections,
        onTap: (Collection collection) => Navigator.of(context)
            .pushNamed(Routes.collection, arguments: collection),
        onDismiss: (Collection collection) => getIt<CollectionsBloc>()
            .add(DeleteCollectionCollectionsEvent(collection)),
        fullScreen: true,
      );
    if (_state is ErrorCollectionsState)
      return ErrorScreen(message: 'Error occured');
    return ErrorScreen(message: Constants.unknownStateMessage);
  }
}
