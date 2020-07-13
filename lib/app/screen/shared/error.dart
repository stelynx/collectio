import 'package:flutter/material.dart';

import '../../../util/constant/translation.dart';
import '../../config/app_localizations.dart';
import '../../theme/style.dart';

class ErrorScreen extends StatelessWidget {
  final Translation _errorMessage;

  const ErrorScreen({@required Translation message}) : _errorMessage = message;

  Translation get errorMessage => _errorMessage;

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
              Text(AppLocalizations.of(context).translate(_errorMessage)),
            ],
          ),
        ),
      ),
    );
  }
}
