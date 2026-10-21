import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSource {
final FirebaseAuth _firebaseAuth;

AuthRemoteDataSource(this._firebaseAuth);

Future<UserCredential> login({
required String email,
required String password,
}) async {
return await _firebaseAuth.signInWithEmailAndPassword(
email: email.trim(),
password: password,
);
}

Future<UserCredential> register({
required String email,
required String password,
}) async {
return await _firebaseAuth.createUserWithEmailAndPassword(
email: email.trim(),
password: password,
);
}

Future<void> logout() async {
await _firebaseAuth.signOut();
}

Stream<User?> get authStateChanges {
return _firebaseAuth.authStateChanges();
}

User? get currentUser => _firebaseAuth.currentUser;
}
