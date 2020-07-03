import 'package:flutter/material.dart';

import '../theme/style.dart';

class CollectioTextField extends StatelessWidget {
  final String labelText;
  final String errorText;
  final String initialValue;
  final int maxLines;
  final bool obscureText;
  final bool enabled;
  final bool showCursor;
  final bool readOnly;
  final IconData icon;
  final VoidCallback onTap;
  final void Function(String) onChanged;

  const CollectioTextField({
    @required this.labelText,
    this.errorText,
    this.initialValue,
    this.onChanged,
    this.icon,
    this.onTap,
    this.maxLines = 1,
    this.obscureText = false,
    this.enabled = true,
    this.showCursor = true,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      autofocus: false,
      maxLines: maxLines,
      obscureText: obscureText,
      enabled: enabled,
      onTap: onTap,
      showCursor: showCursor,
      readOnly: readOnly,
      controller: initialValue == null
          ? null
          : TextEditingController.fromValue(
              TextEditingValue(text: initialValue)),
      decoration: CollectioStyle.textFieldDecoration(
        context: context,
        labelText: labelText,
        errorText: errorText,
        icon: icon,
      ),
      onChanged: onChanged,
    );
  }
}
