import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: AppBar(
          backgroundColor: Colors.amberAccent,
          title: const Text('Login'),
        ),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(hintText: 'Enter your email here'),
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
                    .signInWithEmailAndPassword(email: email, password: password);
                if (kDebugMode) {
                  print(userCredential);
                }
              } on FirebaseAuthException catch (e) {
                // if (kDebugMode) {
                // print(e.code);
                // }
                if (e.code == 'user-not-found') {
                  if (kDebugMode) print('User not found');
                } else {
                  if (kDebugMode) {
                    print('SOMETHING ELSE HAPPENED');
                    print(e.code);
                  }
                }
              } catch (e) {
                if (kDebugMode) {
                  print('something bad happened');
                  // print(e.runtimeType);
                  print(e);
                }
              }
            },
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/register/', (route) => true);
              },
              child: const Text('Not registered yet? Register here!'))
        ],
      ),
    );
  }
}
