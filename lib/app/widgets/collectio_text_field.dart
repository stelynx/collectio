import 'package:flutter/material.dart';

import '../theme/style.dart';

class CollectioTextField extends StatelessWidget {
  final String labelText;
  final String errorText;
  final String initialValue;
  final int maxLines;
  final bool obscureText;
  final bool enabled;
  final void Function(String) onChanged;

  const CollectioTextField({
    @required this.labelText,
    this.errorText,
    this.initialValue,
    this.onChanged,
    this.maxLines = 1,
    this.obscureText = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      autofocus: false,
      maxLines: maxLines,
      obscureText: obscureText,
      enabled: enabled,
      controller: initialValue == null
          ? null
          : TextEditingController.fromValue(
              TextEditingValue(text: initialValue)),
      decoration: InputDecoration(
        labelText: labelText,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 17, vertical: 15),
        enabledBorder:
            OutlineInputBorder(borderRadius: CollectioStyle.borderRadius),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black54),
          borderRadius: CollectioStyle.borderRadius,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
          borderRadius: CollectioStyle.borderRadius,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).errorColor),
          borderRadius: CollectioStyle.borderRadius,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).errorColor),
          borderRadius: CollectioStyle.borderRadius,
        ),
        errorText: errorText,
      ),
      onChanged: onChanged,
    );
  }
}
