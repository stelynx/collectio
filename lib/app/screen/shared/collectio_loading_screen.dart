import 'package:flutter/material.dart';

import '../../../util/constant/constants.dart';
import '../../theme/style.dart';

class CollectioLoadingScreen extends StatelessWidget {
  final String message;

  const CollectioLoadingScreen({this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            CollectioStyle.itemSplitter,
            CollectioStyle.itemSplitter,
            Text(message),
          ],
        ),
      ),
    );
  }
}
