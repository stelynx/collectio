import 'package:flutter/material.dart';

class FailureText extends StatelessWidget {
  final String text;

  const FailureText(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).errorColor,
          fontSize: 15,
        ),
      ),
    );
  }
}
