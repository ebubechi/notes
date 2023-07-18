import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final String id;
  final String email;
  final bool isEmailVerified;
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });

  // making a copy of the firebase user to our class
  factory AuthUser.fromFirebase(User user) => AuthUser(
        id: user.uid,
        email: user.email!, /// * given that we don't have a social auth we are sure that every user in our app has an email
        isEmailVerified: user.emailVerified,
      );
}
