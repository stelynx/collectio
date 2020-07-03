import 'package:flutter/material.dart';

import '../theme/style.dart';

class CollectioTextField extends StatefulWidget {
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
  State<CollectioTextField> createState() => _CollectioTextFieldState();
}

class _CollectioTextFieldState extends State<CollectioTextField> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Focus(
        onFocusChange: (bool focus) => setState(() => _hasFocus = focus),
        child: TextField(
          autocorrect: false,
          autofocus: false,
          maxLines: widget.maxLines,
          obscureText: widget.obscureText,
          enabled: widget.enabled,
          onTap: widget.onTap,
          showCursor: widget.showCursor,
          readOnly: widget.readOnly,
          controller: widget.initialValue == null
              ? null
              : TextEditingController.fromValue(
                  TextEditingValue(text: widget.initialValue)),
          decoration: CollectioStyle.textFieldDecoration(
            context: context,
            labelText: widget.labelText,
            errorText: widget.errorText,
            icon: widget.icon,
            isEmpty: widget.initialValue?.length == 0,
            hasFocus: _hasFocus,
          ),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
