import 'package:flutter/material.dart';

import '../theme/style.dart';

class CollectioButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isPrimary;

  const CollectioButton({
    @required this.onPressed,
    @required this.text,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: isPrimary ? Theme.of(context).backgroundColor : null,
        ),
      ),
      color: isPrimary
          ? Theme.of(context).primaryColor
          : Theme.of(context).buttonColor,
      elevation: CollectioStyle.elevation,
      disabledElevation: 0,
      padding: EdgeInsets.symmetric(vertical: 15.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.0),
      ),
    );
  }
}
