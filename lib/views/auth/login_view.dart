import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/extensions/buildcontext/loc.dart';
// import 'dart:developer' as devtools show log;

// import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
// import 'package:notes/services/auth/auth_service.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/services/auth/bloc/auth_event.dart';
// import 'package:notes/utilities/dialogs/loading_dialog.dart';

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
    final size = MediaQuery.of(context).size;
    // final NavigatorState navigator = Navigator.of(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
              context,
              context.loc.login_error_cannot_find_user,
            );
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
                context, context.loc.login_error_wrong_credentials);
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, context.loc.login_error_auth_error);
          }
        }
      },
      child: Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: const Size.fromHeight(150),
        //   child: AppBar(
        //     backgroundColor: Colors.amberAccent,
        //     title: Padding(
        //       padding: const EdgeInsets.fromLTRB(20.0, 80.0, 0.0, 0.0),
        //       child: Text(
        //         context.loc.login,
        //         style:
        //             const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        //       ),
        //     ),
        //   ),
        // ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                width: size.width,
                height: size.height * 0.2,
                color: Colors.amberAccent,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 80.0, 0.0, 0.0),
                  child: Text(
                    context.loc.login,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        context.loc.login_view_prompt,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        controller: _email,
                        decoration: InputDecoration(
                            hintText: context.loc.email_text_field_placeholder,
                            filled: true,
                            fillColor: const Color(0x59D9D9D9),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none)),
                        keyboardType: TextInputType.emailAddress,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        controller: _password,
                        decoration: InputDecoration(
                          hintText: context.loc.password_text_field_placeholder,
                          filled: true,
                          fillColor: const Color(0x59D9D9D9),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black, // Text color
                          padding: const EdgeInsets.all(
                              16), // Padding around the button's text
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14), // Rounded corners
                          ),
                        ),
                        child: Text(context.loc.login),
                        onPressed: () async {
                          final email = _email!.text;
                          final password = _password!.text;
                          context.read<AuthBloc>().add(AuthEventLogIn(
                                email,
                                password,
                              ));
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
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                const AuthEventForgotPassword(),
                              );
                        },
                        child: Text(context.loc.login_view_forgot_password),
                      ),
                      TextButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  const AuthEventShouldRegister(),
                                );
                            // navigator.pushNamedAndRemoveUntil(
                            //     registerRoutes, (route) => true);
                          },
                          child: Text(context.loc.login_view_not_registered_yet)),
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
