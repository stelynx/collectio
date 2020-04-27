import 'package:flutter/material.dart';

import '../../../../model/collection.dart';
import 'widgets/collection_details_view.dart';

class CollectionScreen extends StatelessWidget {
  final Collection _collection;

  const CollectionScreen(this._collection);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            color: ThemeData.light().accentColor,
            indent: 20,
            endIndent: 20,
          ),
        ],
      ),
    );
  }
}
