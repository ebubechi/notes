import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<bool> showLogOutDialog(
  BuildContext context,
) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log Out',
    content: 'Are you sure you want to log out?',
    optionsBuilder: () => {
      'Cancel': false,
      'Log out': true,
    },
  ).then((value) => value ?? false);
}

// Future<bool> showLogOutDialog(BuildContext context) {
//   return showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Sign out'),
//           content: const Text('Are you sure you want to Sign out?'),
//           actions: [
//             TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(false);
//                 },
//                 child: const Text('Cancel')),
//             TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(true);
//                 },
//                 child: const Text('Log out')),
//           ],
//         );
//       }).then((value) => value ?? false);
// }