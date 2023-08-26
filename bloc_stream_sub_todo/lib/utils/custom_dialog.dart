import 'package:flutter/material.dart';

class CustomDialog {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    VoidCallback? positiveAction,
    String positiveText = 'Acept',
    VoidCallback? negativeAction,
    String negativeText = 'Cancel',
  }) async {
    return showDialog<T>(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content,
        actions: [
          TextButton(
            onPressed: negativeAction ??
                () {
                  Navigator.pop(context);
                },
            child: Text(negativeText),
          ),
          if (positiveAction != null)
            TextButton(
              onPressed: positiveAction,
              child: Text(positiveText),
            ),
        ],
      ),
    );
  }
}
