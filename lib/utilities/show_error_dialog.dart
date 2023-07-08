
import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  final navigator = Navigator.of(context);
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('An error occurred'),
          content: Text(text),
          actions: [
            TextButton(
                onPressed: () {
                  navigator.pop();
                },
                child: const Text('OK'))
          ],
        );
      });
}
