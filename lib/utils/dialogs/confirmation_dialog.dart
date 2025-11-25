import 'package:flutter/material.dart';

Future<bool?> showConfirmationDialog(BuildContext context, String text) {
  return showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
          ],
        ),
  );
}
