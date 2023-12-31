import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/extensions/buildcontext/loc.dart';
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
    final size = MediaQuery.of(context).size;
    // final navigator = Navigator.of(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
                context, context.loc.register_error_weak_password);
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
                context, context.loc.register_error_email_already_in_use);
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              context.loc.register_error_generic,
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
                context, context.loc.register_error_invalid_email);
          }
        }
      },
      child: Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: const Size.fromHeight(150),
        //   child: AppBar(
        //     automaticallyImplyLeading: false,
        //     backgroundColor: Colors.amberAccent,
        //     title: Text(
        //       context.loc.register,
        //       style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        //     ),
        //   ),
        // ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width,
                height: size.height * 0.2,
                color: Colors.amberAccent,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 80.0, 0.0, 0.0),
                  child: Text(
                    context.loc.register,
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
                      context.loc.register_view_prompt,
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
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      enableSuggestions: false,
                      autocorrect: false,
                      autofocus: true,
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
                    Center(
                      child: Column(
                        children: [
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
                            child: Text(context.loc.register),
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
                              child: Text(
                                  context.loc.register_view_already_registered)),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
