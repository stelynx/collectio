import 'package:flutter/material.dart';

class CollectioStyle {
  static const double elevation = 10.0;
  static const double bigIconSize = 80.0;
  static const SizedBox itemSplitter = const SizedBox(height: 10.0);
  static const EdgeInsets screenPadding = const EdgeInsets.all(20.0);
  static BorderRadius borderRadius = BorderRadius.circular(20.0);

  static InputDecoration textFieldDecoration({
    @required BuildContext context,
    @required String labelText,
    String errorText,
  }) =>
      InputDecoration(
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
      );
}
