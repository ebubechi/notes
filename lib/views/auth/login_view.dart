import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'dart:developer' as devtools show log;

import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
// import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';

import '../../services/auth/bloc/auth_state.dart';
import '../../utilities/dialogs/show_error_dialog.dart';

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
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) async {
                if (state is AuthStateLoggedOut) {
                  if (state.exception is UserNotFoundAuthException) {
                    await showErrorDialog(context, 'User not found');
                  } else if (state.exception is WrongPasswordAuthException) {
                    await showErrorDialog(context, 'Wrong credentials');
                  } else {
                    await showErrorDialog(context, 'Authentication Error');
                  }
                }
              },
              child: TextButton(
                child: const Text('Login'),
                onPressed: () async {
                  final email = _email!.text;
                  final password = _password!.text;
                  // try {
                  //   context
                  //       .read<AuthBloc>()
                  //       .add(AuthEventLogIn(email, password));
                  //   // await AuthService.firebase().logIn(email: email, password: password);
                  // } on UserNotFoundAuthException {
                  //   await showErrorDialog(context, 'User not found');
                  // } on WrongPasswordAuthException {
                  //   await showErrorDialog(context, 'Wrong password');
                  // } on GenericAuthException {
                  //   await showErrorDialog(context, 'Authentication error');
                  // }
                  context.read<AuthBloc>().add(
                        AuthEventLogIn(
                          email,
                          password,
                        ),
                      );
                },
              ),
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
