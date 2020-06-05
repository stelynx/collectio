import 'package:flutter/material.dart';

import '../../theme/style.dart';

class ErrorScreen extends StatelessWidget {
  final String _errorMessage;

  const ErrorScreen({@required String message}) : _errorMessage = message;

  String get errorMessage => _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: CollectioStyle.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.error,
                size: CollectioStyle.bigIconSize,
                color: Theme.of(context).errorColor,
              ),
              CollectioStyle.itemSplitter,
              Text(_errorMessage),
            ],
          ),
        ),
      ),
    );
  }
}
