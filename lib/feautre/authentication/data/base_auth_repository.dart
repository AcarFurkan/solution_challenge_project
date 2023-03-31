 import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> userStream();
  AppUser? get currentUser;
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future<void> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError();
});
