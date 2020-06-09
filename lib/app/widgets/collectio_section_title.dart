import 'package:flutter/material.dart';

import '../theme/style.dart';

class CollectioSectionTitle extends StatelessWidget {
  final String sectionTitle;
  final String sectionDescription;
  final bool parentHasPadding;

  const CollectioSectionTitle(
    this.sectionTitle, {
    this.sectionDescription,
    this.parentHasPadding = false,
  });

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
            sectionTitle,
            style: Theme.of(context).textTheme.headline2,
          ),
          Divider(color: Theme.of(context).textTheme.headline2.color),
          if (sectionDescription != null) ...[
            Text(sectionDescription),
          ],
        ],
      ),
    );
  }
}
