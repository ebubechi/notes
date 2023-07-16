import 'package:flutter_test/flutter_test.dart';
import 'package:notes/services/auth/auth_exceptions.dart';
import 'package:notes/services/auth/auth_provider.dart';
import 'package:notes/services/auth/auth_user.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });
    test('Cannot log out if not  initialized', () {
      expect(provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });
    test('Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });
    test('User should to be null upon initialization', () {
      expect(provider.currentUser, null);
    });
    test(
      'Create user should delegate to login function',
      () async {
        final badEmailUser = provider.createUser(
            email: 'uzo@gmail.com', password: 'anypassword');
        expect(badEmailUser,
            throwsA(const TypeMatcher<UserNotFoundAuthException>()));
        final badPasswordUser =
            provider.createUser(email: 'email', password: 'ebube');
        expect(badPasswordUser,
            throwsA(const TypeMatcher<WrongPasswordAuthException>()));

        final user = await provider.createUser(
            email: 'emmanuelsonzico@gmail.com', password: 'ebube007');
        expect(provider.currentUser, user);
        expect(user.isEmailVerified, false);
      },
    );
    test('Login user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    test('Should be able to login and logout again', () async {
      await provider.logOut();
      await provider.logIn(
          email: 'emmanuelsonzico@gmail.com', password: 'ebube007');
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user; // because it's nullable it's by default false

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'uzo@gmail.com') throw UserNotFoundAuthException();
    if (password == 'ebube') throw WrongPasswordAuthException();
    const user = AuthUser(
      email: '',
      isEmailVerified: false,
    );
    _user = user;
    return Future.value(_user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(
      isEmailVerified: true,
      email: '',
    );
    _user = newUser;
  }
}
