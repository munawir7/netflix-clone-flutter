import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
Future<User?> login({
required String email,
required String password,
});

Future<User?> register({
required String email,
required String password,
});

Future<void> logout();

Stream<User?> get authStateChanges;

User? get currentUser;
}
