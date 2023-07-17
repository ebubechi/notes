import 'package:flutter/material.dart';
// import 'dart:developer' as devtools show log;;

import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/utilities/dialogs/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.amberAccent,
          title: const Text('Register'),
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
              child: const Text('Register'),
              onPressed: () async {
                final email = _email!.text;
                final password = _password!.text;
                try {
                  await AuthService.firebase()
                      .createUser(email: email, password: password);
                  await AuthService.firebase().sendEmailVerification();
                   navigator.pushNamed(verifyEmailRoutes);
                } on WeakPasswordAuthException {
                  await showErrorDialog(context, 'Weak Password');
                } on EmailAlreadyInUseAuthException {
                  await showErrorDialog(context, 'Email is already exist');
                } on InvalidEmailAuthException {
                  await showErrorDialog(context, 'This is an invalid email');
                } on GenericAuthException {
                  await showErrorDialog(context, 'Registration Error');
                }
              },
            ),
            TextButton(
                onPressed: () {
                  navigator.pushNamedAndRemoveUntil(
                      loginRoutes, (route) => false);
                },
                child: const Text('Already registered? Login here!'))
          ],
        ),
      ),
    );
  }
}
