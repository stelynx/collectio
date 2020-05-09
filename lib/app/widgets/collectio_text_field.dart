import 'package:flutter/material.dart';

class CollectioTextField extends StatelessWidget {
  final String labelText;
  final String errorText;
  final int maxLines;
  final bool obscureText;
  final void Function(String) onChanged;

  const CollectioTextField({
    @required this.labelText,
    @required this.errorText,
    @required this.onChanged,
    this.maxLines = 1,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      autofocus: false,
      maxLines: maxLines,
      obscureText: obscureText,
      decoration: InputDecoration(
          labelText: labelText,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
          enabledBorder: OutlineInputBorder(),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
          errorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          focusedErrorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          errorText: errorText),
      onChanged: onChanged,
    );
  }
}
