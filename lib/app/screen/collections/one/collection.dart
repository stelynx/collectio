import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/collection.dart';
import '../../../../model/collection_item.dart';
import '../../../../util/constant/constants.dart';
import '../../../../util/injection/injection.dart';
import '../../../bloc/collections/collection_items_bloc.dart';
import '../../../routes/routes.dart';
import '../../../widgets/collectio_list.dart';
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
          CollectionDetailsView(_collection),
          Divider(
            color: Theme.of(context).primaryColor,
            indent: 20,
            endIndent: 20,
          ),
          BlocBuilder<CollectionItemsBloc, CollectionItemsState>(
            bloc: getIt<CollectionItemsBloc>()
              ..add(GetCollectionItemsEvent(_collection)),
            builder: (BuildContext context, CollectionItemsState state) {
              if (state is LoadedCollectionItemsState)
                return Expanded(
                  child: CollectioList(
                    items: state.collectionItems,
                    onTap: (CollectionItem item) => Navigator.of(context)
                        .pushNamed(Routes.item, arguments: item),
                    onDismiss: (CollectionItem item) =>
                        getIt<CollectionItemsBloc>()
                            .add(DeleteItemCollectionItemsEvent(item)),
                  ),
                );

              if (state is ErrorCollectionItemsState)
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 30),
                        Icon(
                          Icons.error,
                          size: 80,
                          color: Theme.of(context).errorColor,
                        ),
                        SizedBox(height: 10),
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
