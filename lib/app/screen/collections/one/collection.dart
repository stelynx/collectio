import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/collection.dart';
import '../../../../model/collection_item.dart';
import '../../../../util/constant/constants.dart';
import '../../../../util/injection/injection.dart';
import '../../../bloc/collections/collection_items_bloc.dart';
import '../../../routes/routes.dart';
import '../../../theme/style.dart';
import '../../../widgets/collectio_list.dart';
import '../../../widgets/collectio_text_field.dart';
import '../../../widgets/collectio_toast.dart';
import 'widgets/collection_details_view.dart';

class CollectionScreen extends StatelessWidget {
  final Collection _collection;

  const CollectionScreen(this._collection);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: <Widget>[
            Text(
              _collection.title,
              style: TextStyle(fontSize: 18),
            ),
            Text(
              _collection.subtitle,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CollectionDetailsView(_collection),
          ),
          BlocBuilder<CollectionItemsBloc, CollectionItemsState>(
            bloc: getIt<CollectionItemsBloc>()
              ..add(GetCollectionItemsEvent(_collection)),
            builder: (BuildContext context, CollectionItemsState state) {
              if (state is LoadedCollectionItemsState) {
                final LoadedCollectionItemsState loadedCollectionItemsState =
                    state;
                if (loadedCollectionItemsState.toastMessage != null) {
                  final SnackBar snackBar = CollectioToast(
                    message: loadedCollectionItemsState.toastMessage,
                    toastType: loadedCollectionItemsState.toastType,
                  );
                  WidgetsBinding.instance.addPostFrameCallback(
                      (_) => Scaffold.of(context).showSnackBar(snackBar));
                }
                return Expanded(
                  child: Column(
                    children: <Widget>[
                      if (state.collectionItems.length > 0) ...[
                        if (!state.isSearching) ...[
                          Container(
                            height: 50,
                            child: GestureDetector(
                              onTap: () => getIt<CollectionItemsBloc>()
                                  .add(ToggleSearchCollectionItemsEvent()),
                              child: Icon(Icons.search),
                            ),
                          ),
                        ] else ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 20),
                            child: Container(
                              height: 50,
                              child: Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () => getIt<CollectionItemsBloc>()
                                        .add(
                                            ToggleSearchCollectionItemsEvent()),
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Icon(Icons.close),
                                    ),
                                  ),
                                  Expanded(
                                    child: CollectioTextField(
                                      labelText: null,
                                      onChanged: (String value) =>
                                          getIt<CollectionItemsBloc>().add(
                                              SearchQueryChangedCollectionItemsEvent(
                                                  value)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                      Expanded(
                        child: CollectioList(
                          items: state.displayedCollectionItems,
                          onTap: (CollectionItem item) => Navigator.of(context)
                              .pushNamed(Routes.item, arguments: item),
                          onDismiss: (CollectionItem item) =>
                              getIt<CollectionItemsBloc>()
                                  .add(DeleteItemCollectionItemsEvent(item)),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state is ErrorCollectionItemsState)
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: <Widget>[
                        CollectioStyle.itemSplitter,
                        CollectioStyle.itemSplitter,
                        CollectioStyle.itemSplitter,
                        Icon(
                          Icons.error,
                          size: CollectioStyle.bigIconSize,
                          color: Theme.of(context).errorColor,
                        ),
                        CollectioStyle.itemSplitter,
                        Text(
                          Constants.collectionItemsFailure,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );

              return Center(
                  child: Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: CircularProgressIndicator(),
              ));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(
          Routes.newItem,
          arguments: _collection,
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
