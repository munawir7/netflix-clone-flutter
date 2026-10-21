import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:netflix_clone/data/repositories/auth_repository.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';
import '../../domain/usecases/register_user.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
return FirebaseAuth.instance;
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
return AuthRemoteDataSource(
ref.watch(firebaseAuthProvider),
);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
return AuthRepositoryImpl(
ref.watch(authRemoteDataSourceProvider),
);
});

final loginUserProvider = Provider<LoginUser>((ref) {
return LoginUser(
ref.watch(authRepositoryProvider),
);
});

final registerUserProvider = Provider<RegisterUser>((ref) {
return RegisterUser(
ref.watch(authRepositoryProvider),
);
});

final logoutUserProvider = Provider<LogoutUser>((ref) {
return LogoutUser(
ref.watch(authRepositoryProvider),
);
});

final authStateProvider = StreamProvider<User?>((ref) {
return ref.watch(authRepositoryProvider).authStateChanges;
});

final currentUserProvider = Provider<User?>((ref) {
return ref.watch(authRepositoryProvider).currentUser;
});
