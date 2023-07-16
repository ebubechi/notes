import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/views/login_view.dart';
import 'package:notes/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

import 'services/auth/auth_user.dart';
import 'views/notes/new_note_view.dart';
import 'views/notes/notes_view.dart';
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
      newNotesRoutes:(context) =>  const NewNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
          future: AuthService.firebase().initialize(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final AuthUser? user = AuthService.firebase().currentUser;
                if (user != null) {
                  if (user.isEmailVerified) {
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