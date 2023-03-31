import 'package:firebase_auth/firebase_auth.dart';
 import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solution_challenge_project/core/enum/fireauth_request_enum.dart';
import 'package:solution_challenge_project/core/exceptions/custom_firebase_exception.dart';

class CoreFirebase {
  Future get(FirebaseAuthTypes type, {String? email, String? password}) async {
    try {
      switch (type) {
        case FirebaseAuthTypes.login:
          return await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email!, password: password!);
        case FirebaseAuthTypes.register:
          return await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email!, password: password!);
        case FirebaseAuthTypes.signOut:
          return await FirebaseAuth.instance.signOut();
        default:
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseCustomExceptions.convertFirebaseMessage(e.code);
    } catch (_) {}
  }
}

final coreFirebaseProvider = Provider<CoreFirebase>((ref) {
  return CoreFirebase();
});
