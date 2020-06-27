import 'package:flutter/material.dart';

import '../theme/style.dart';

enum ToastType {
  error,
  warning,
  success,
}

class CollectioToast extends SnackBar {
  CollectioToast({
    @required String message,
    ToastType toastType,
  }) : super(
          content: Container(
            height: 50.0,
            decoration: BoxDecoration(
              borderRadius: CollectioStyle.borderRadius,
              color: _getToastColor(toastType),
            ),
            child: Center(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 15,
                  color: toastType == null ? Colors.black : null,
                ),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: const Duration(milliseconds: 1250),
        );

  static Color _getToastColor(ToastType type) {
    switch (type) {
      case ToastType.error:
        return Colors.red;
      case ToastType.warning:
        return Colors.amber;
      case ToastType.success:
        return Colors.green[500];
      default:
        return Colors.grey[350];
    }
  }
}
