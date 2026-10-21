import 'package:firebase_auth/firebase_auth.dart';

import '../repositories/auth_repository.dart';

class RegisterUser {
final AuthRepository _repository;

RegisterUser(this._repository);

Future<User?> call({
required String email,
required String password,
}) {
return _repository.register(
email: email,
password: password,
);
}
}
