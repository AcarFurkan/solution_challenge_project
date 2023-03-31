import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
 import 'package:solution_challenge_project/core/enum/fireauth_request_enum.dart';

import '../domain/app_user.dart';
import 'base_auth_repository.dart';
import 'core_firebase.dart';

// TODO: TRY CATCHLER BURADA MI OLMALI?
// TODO: TRY CATCHLERE BASE CLASS YAPAYIM MI?
class FirebaseAuthRepository extends AuthRepository {
  late CoreFirebase coreFirebase;
  final Ref ref;
  FirebaseAuthRepository({
    required this.ref,
  }) {
    coreFirebase = ref.read(coreFirebaseProvider);
  }
  @override
  Stream<AppUser?> userStream() async* {
    await for (final user in FirebaseAuth.instance.authStateChanges()) {
      if (user == null) {
        yield null;
      } else {
        yield AppUser.fromFirebaseUser(user);
      }
    }
  }

  @override
  AppUser? get currentUser => FirebaseAuth.instance.currentUser != null
      ? AppUser.fromFirebaseUser(FirebaseAuth.instance.currentUser!)
      : null;

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    return coreFirebase.get(FirebaseAuthTypes.login,
        email: email, password: password);
  }

  @override
  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    return coreFirebase.get(FirebaseAuthTypes.register,
        email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    return coreFirebase.get(FirebaseAuthTypes.signOut);
  }
}

final firebaseAuthRepositoryProvider = Provider<FirebaseAuthRepository>((ref) {
  return FirebaseAuthRepository(ref: ref);
});
