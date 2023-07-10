import 'auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<AuthUser> login({required String email, required String password});
  Future<AuthUser> createUser({required String email, required String password});
  Future<AuthUser> sendEmailVerification();
  Future<AuthUser> logout();
  
}