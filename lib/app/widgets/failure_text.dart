import 'package:flutter/material.dart';

import '../../util/constant/translation.dart';
import '../config/app_localizations.dart';

class FailureText extends StatelessWidget {
  final Translation text;

  const FailureText(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context).translate(text),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).errorColor,
          fontSize: 15,
        ),
      ),
    );
  }
}
