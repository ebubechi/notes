import 'package:flutter/material.dart';
import 'package:notes/services/navigation/navigator_service.dart';

final NavigatorService _navigatorService = NavigatorService();

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
}) {
  final options = optionsBuilder();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTitle) {
          final T value = options[optionTitle];
          return TextButton(
            onPressed: () {
              // if (value != null) {
              //   Navigator.of(context).pop(value);
              // } else {
              //   Navigator.of(context).pop();
              // }
              _navigatorService.navPop(
                  context, value); // Take note of this navigation service
            },
            child: Text(optionTitle),
          );
        }).toList(),
      );
    },
  );
}
