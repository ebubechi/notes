import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

import 'firebase_options.dart';
import 'views/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [],
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white, statusBarIconBrightness: Brightness.dark));
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true),
    home: const HomePage(),
    routes: {
      loginRoutes: (context) => const LoginView(),
      registerRoutes: (context) => const RegisterView(),
      notesRoutes: (context) => const NotesView(),
      verifyEmailRoutes: (context) => const VerifyEmailView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  if (user.emailVerified) {
                    devtools.log('Email is verified');
                    return const NotesView();
                  } else {
                    return const VerifyEmailView();
                  }
                } else {
                  return const LoginView();
                }
              default:
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
            }
          }),
    );
  }
}

enum MenuAction { logout }

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
                      devtools.log(shouldLogout.toString());
                      if (shouldLogout) {
                        await FirebaseAuth.instance.signOut();
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
