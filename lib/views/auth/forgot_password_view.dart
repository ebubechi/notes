// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/extensions/buildcontext/loc.dart';
import 'package:notes/services/auth/bloc/auth_bloc.dart';
import 'package:notes/services/auth/bloc/auth_state.dart';
import 'package:notes/utilities/dialogs/password_reset_email_sent_dialog.dart';

import '../../services/auth/bloc/auth_event.dart';
import '../../utilities/dialogs/show_error_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            // ignore: use_build_context_synchronously
            await showErrorDialog(
                context,
                // ignore: use_build_context_synchronously
                context.loc.forgot_password_view_generic_error);
          }
        }
      },
      child: Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: const Size.fromHeight(150),
        //   child: AppBar(
        //     backgroundColor: Colors.amberAccent,
        //     title: Column(
        //       children: [
        //         const SizedBox(
        //           height: 50.0,
        //         ),
        //         Text(context.loc.forgot_password),
        //       ],
        //     ),
        //   ),
        // ),

        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: size.width,
                height: size.height * 0.2,
                color: Colors.amberAccent,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 80.0, 0.0, 0.0),
                  child: Text(
                    context.loc.forgot_password,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(context.loc.forgot_password_view_prompt),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      autofocus: true,
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: context.loc.email_text_field_placeholder,
                        filled: true,
                        fillColor: const Color(0x59D9D9D9),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        final email = _controller.text;
                        context
                            .read<AuthBloc>()
                            .add(AuthEventForgotPassword(email: email));
                      },
                      child:
                          Text(context.loc.forgot_password_view_send_me_link),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              const AuthEventLogOut(),
                            );
                      },
                      child:
                          Text(context.loc.forgot_password_view_back_to_login),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
