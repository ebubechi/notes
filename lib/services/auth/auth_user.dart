import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final String? email;
  final bool isEmailVerified;
  const AuthUser({
    required this.email, 
    required this.isEmailVerified,
  });

  // making a copy of the firebase user to our class
  factory AuthUser.fromFirebase(User user) => AuthUser(
        email: user.email,
        isEmailVerified: user.emailVerified,
      );
}
