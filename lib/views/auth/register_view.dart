import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'dart:developer' as devtools show log;;

// import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
// import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
// import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/utilities/dialogs/show_error_dialog.dart';

import '../../services/auth/bloc/auth_bloc.dart';
import '../../services/auth/bloc/auth_state.dart';

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
    // final navigator = Navigator.of(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak Password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email already in use');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              'Failed to register, check internet connection',
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid email');
          }
        }
      },
      child: Scaffold(
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    'Enter your email and password to see your notes!'),
                TextField(
                  controller: _email,
                  decoration:
                      const InputDecoration(hintText: 'Enter your email here'),
                  keyboardType: TextInputType.emailAddress,
                  enableSuggestions: false,
                  autocorrect: false,
                  autofocus: true,
                ),
                TextField(
                  controller: _password,
                  decoration:
                      const InputDecoration(hintText: 'Enter your password here'),
                  obscureText: true,
                ),
                Center(
                  child: Column(
                    children: [
                      TextButton(
                        child: const Text('Register'),
                        onPressed: () async {
                          final email = _email!.text;
                          final password = _password!.text;
                          // try {
                          //   // context.read<AuthBloc>().add( AuthEventR );
                          //   await AuthService.firebase()
                          //       .createUser(email: email, password: password);
                          //   await AuthService.firebase().sendEmailVerification();
                          //   navigator.pushNamed(verifyEmailRoutes);
                          // } on WeakPasswordAuthException {
                          //   await showErrorDialog(context, 'Weak Password');
                          // } on EmailAlreadyInUseAuthException {
                          //   await showErrorDialog(context, 'Email is already exist');
                          // } on InvalidEmailAuthException {
                          //   await showErrorDialog(context, 'This is an invalid email');
                          // } on GenericAuthException {
                          //   await showErrorDialog(context, 'Registration Error');
                          // }
                          context
                              .read<AuthBloc>()
                              .add(AuthEventRegister(email, password));
                        },
                      ),
                      TextButton(
                          onPressed: () {
                            // navigator.pushNamedAndRemoveUntil(
                            //     loginRoutes, (route) => false);
                            context.read<AuthBloc>().add(
                                  const AuthEventLogOut(),
                                );
                          },
                          child: const Text('Already registered? Login here!')),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
