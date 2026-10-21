import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
final AuthRemoteDataSource _dataSource;

AuthRepositoryImpl(this._dataSource);

@override
Future<User?> login({
required String email,
required String password,
}) async {
final credential = await _dataSource.login(
email: email,
password: password,
);


return credential.user;


}

@override
Future<User?> register({
required String email,
required String password,
}) async {
final credential = await _dataSource.register(
email: email,
password: password,
);


return credential.user;


}

@override
Future<void> logout() async {
await _dataSource.logout();
}

@override
Stream<User?> get authStateChanges {
return _dataSource.authStateChanges;
}

@override
User? get currentUser => _dataSource.currentUser;
}
