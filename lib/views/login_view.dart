import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:notes/constants/routes.dart';

import '../utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late TextEditingController? _email;
  late TextEditingController? _password;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email?.dispose();
    _password?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NavigatorState navigator = Navigator.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: AppBar(
          backgroundColor: Colors.amberAccent,
          title: const Text('Login'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration:
                  const InputDecoration(hintText: 'Enter your email here'),
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: false,
              autocorrect: false,
            ),
            TextField(
              controller: _password,
              decoration:
                  const InputDecoration(hintText: 'Enter your password here'),
              obscureText: true,
            ),
            TextButton(
              child: const Text('Login'),
              onPressed: () async {
                final email = _email!.text;
                final password = _password!.text;
                try {
                  final userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email, password: password);
                  devtools.log(userCredential.toString());
                  if (userCredential.user?.emailVerified == true) {
                    navigator.pushNamedAndRemoveUntil(
                        notesRoutes, (route) => false);
                  } else {
                    navigator.pushNamedAndRemoveUntil(
                        verifyEmailRoutes, (route) => false);
                  }
                } on FirebaseAuthException catch (e) {
                  // if (kDebugMode) {
                  // devtools.log(e.code);
                  // }
                  if (e.code == 'user-not-found') {
                    await showErrorDialog(
                      context,
                      'User not found',
                    );
                  } else if (e.code == 'wrong-password') {
                    devtools.log('SOMETHING ELSE HAPPENED');
                    devtools.log(e.code);
                    await showErrorDialog(
                      context,
                      'Wrong password',
                    );
                  } else {
                    // any other Firebase exception that might occur
                    await showErrorDialog(
                      context,
                      'Error: ${e.code}',
                    );
                  }
                } catch (e) {
                  // any other non Firebase exception that might occur
                  await showErrorDialog(
                    context,
                    e.toString(),
                  );
                }
              },
            ),
            TextButton(
                onPressed: () {
                  navigator.pushNamedAndRemoveUntil(
                      registerRoutes, (route) => true);
                },
                child: const Text('Not registered yet? Register here!'))
          ],
        ),
      ),
    );
  }
}
