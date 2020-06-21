import 'package:flutter/material.dart';

import '../../../../../model/collection.dart';
import '../../../../../util/constant/translation.dart';
import '../../../../../util/injection/injection.dart';
import '../../../../bloc/collections/collections_bloc.dart';
import '../../../../config/app_localizations.dart';
import '../../../../routes/routes.dart';
import '../../../../widgets/collectio_list.dart';
import '../../../../widgets/collectio_toast.dart';
import '../../../shared/error.dart';

class CollectionsBody extends StatelessWidget {
  final CollectionsState _state;

  const CollectionsBody({@required CollectionsState collectionsState})
      : _state = collectionsState;

  @override
  Widget build(BuildContext context) {
    if (_state is LoadedCollectionsState) {
      final LoadedCollectionsState loadedCollectionsState = _state;
      if (loadedCollectionsState.toastMessage != null) {
        final SnackBar snackBar = CollectioToast(
          message: AppLocalizations.of(context)
              .translate(loadedCollectionsState.toastMessage),
          toastType: loadedCollectionsState.toastType,
        );
        WidgetsBinding.instance.addPostFrameCallback(
            (_) => Scaffold.of(context).showSnackBar(snackBar));
      }
      return CollectioList(
        items: (_state as LoadedCollectionsState).displayedCollections,
        onTap: (Collection collection) => Navigator.of(context)
            .pushNamed(Routes.collection, arguments: collection),
        onDismiss: (Collection collection) => getIt<CollectionsBloc>()
            .add(DeleteCollectionCollectionsEvent(collection)),
        fullScreen: true,
      );
    }
    if (_state is ErrorCollectionsState)
      return ErrorScreen(message: Translation.errorOccured);

    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
