import 'package:flutter/material.dart';

import '../theme/style.dart';

class CollectioSectionTitle extends StatelessWidget {
  final String text;
  final bool parentHasPadding;

  const CollectioSectionTitle(this.text, {this.parentHasPadding = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(parentHasPadding ? 0 : 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CollectioStyle.itemSplitter,
          CollectioStyle.itemSplitter,
          Text(
            text,
            style: Theme.of(context).textTheme.headline2,
          ),
          Divider(color: Theme.of(context).textTheme.headline2.color),
        ],
      ),
    );
  }
}
