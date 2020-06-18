import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../util/constant/translation.dart';
import '../../../../util/injection/injection.dart';
import '../../../bloc/collections/collections_bloc.dart';
import '../../../config/app_localizations.dart';
import '../../../routes/routes.dart';
import '../../../widgets/collectio_drawer.dart';
import '../../../widgets/collectio_text_field.dart';
import 'widgets/collections_body.dart';

class CollectionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionsBloc, CollectionsState>(
      bloc: getIt<CollectionsBloc>(),
      builder: (BuildContext context, CollectionsState state) => Scaffold(
        appBar: AppBar(
          title: state is LoadedCollectionsState && state.isSearching
              ? CollectioTextField(
                  labelText: null,
                  onChanged: (String value) => getIt<CollectionsBloc>()
                      .add(SearchQueryChangedCollectionsEvent(value)),
                )
              : Text(AppLocalizations.of(context)
                  .translate(Translation.titleCollectionsScreen)),
          leading: state is LoadedCollectionsState &&
                  state.collections.length > 0
              ? GestureDetector(
                  onTap: () => getIt<CollectionsBloc>()
                      .add(ToggleSearchCollectionsEvent()),
                  child: Icon(state.isSearching ? Icons.close : Icons.search),
                )
              : null,
        ),
        endDrawer: CollectioDrawer(),
        body: CollectionsBody(collectionsState: state),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              Navigator.of(context).pushNamed(Routes.newCollection),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
