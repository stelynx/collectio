import 'package:flutter/material.dart';

class CollectioButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const CollectioButton({
    @required this.onPressed,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
