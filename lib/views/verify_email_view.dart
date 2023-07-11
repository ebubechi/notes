import 'package:flutter/material.dart';
import 'package:notes/constants/routes.dart';
import 'package:notes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: AppBar(
          backgroundColor: Colors.amberAccent,
          title: const Text('Verify Email'),
        ),
      ),
      body: Column(children: [
        const Text(
            'We\'ve sent you an email verification. Please open it to verify your account. '),
        const Text(
            'If you haven\'t received a verification email yet, press the button below'),
        TextButton(
          child: const Text('send email verification'),
          onPressed: () async {
            await AuthService.firebase().sendEmailVerification();
          },
        ),
        TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              navigator.pushNamedAndRemoveUntil(
                  registerRoutes, (route) => false);
            },
            child: const Text('Restart registration'))
      ]),
    );
  }
}
