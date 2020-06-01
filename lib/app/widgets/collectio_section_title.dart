import 'package:flutter/material.dart';

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
          const SizedBox(height: 20),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Divider(color: Theme.of(context).primaryColor),
        ],
      ),
    );
  }
}
