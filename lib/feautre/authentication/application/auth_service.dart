import 'package:flutter_riverpod/flutter_riverpod.dart';
 import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/base_auth_repository.dart';
import '../data/firebase_auth_repository.dart';
import '../domain/app_user.dart';
part 'auth_service.g.dart';

class AuthService {
  Ref ref;
  late final AuthRepository authRepository;
  AuthService({
    required this.ref,
  }) {
    authRepository = ref.read(firebaseAuthRepositoryProvider);
  }

  Future<void> signInWithEmailAndPassword(
          String email, String password) async =>
      authRepository.signInWithEmailAndPassword(email, password);

  Future<void> createUserWithEmailAndPassword(
          String email, String password) async =>
      authRepository.createUserWithEmailAndPassword(email, password);

  Future<void> signOut() async => await authRepository.signOut();

  AppUser? get currentUser => authRepository.currentUser;

  Stream<AppUser?> userStream() => authRepository.userStream();
}

@Riverpod(keepAlive: true)
AuthService authService(Ref ref) {
  return AuthService(ref: ref);
}
