import 'package:flutter/material.dart';
import 'package:notes/services/auth/auth_service.dart';

import '../constants/routes.dart';
import '../enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150), 
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.amberAccent,
            title: const Text('Main UI'),
            actions: [
              PopupMenuButton<MenuAction>(
                itemBuilder: (BuildContext context) {
                  return const [
                    PopupMenuItem<MenuAction>(
                      value: MenuAction.logout,
                      child: Text('Log out'),
                    )
                  ];
                },
                onSelected: (value) async {
                  switch (value) {
                    case MenuAction.logout:
                      final shouldLogout = await showLogOutDialog(context);
                      // devtools.log(shouldLogout.toString());
                      if (shouldLogout) {
                        await AuthService.firebase().logOut();
                        navigator.pushNamedAndRemoveUntil(
                            loginRoutes, (_) => false);
                      }
                  }
                },
              )
            ],
          ),
        ),
        body: const Column(
          children: [Text('Hello world')],
        ));
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are you sure you want to Sign out?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Log out')),
          ],
        );
      }).then((value) => value ?? false);
}
