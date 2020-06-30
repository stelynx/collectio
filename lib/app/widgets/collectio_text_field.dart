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
      decoration: CollectioStyle.textFieldDecoration(
        context: context,
        labelText: labelText,
        errorText: errorText,
      ),
      onChanged: onChanged,
    );
  }
}
