 import 'package:solution_challenge_project/core/exceptions/app_exception.dart';

class FirebaseCustomExceptions {
  static AppException convertFirebaseMessage(String exception) {
    exception is TooManyRequest;
    switch (exception) {
      case 'email-already-in-use':
        return const AppException.emailAlreadyInUse();
      case 'user-not-found':
        return const AppException.userNotFound();
      case 'weak-password':
        return const AppException.weakPassword();
      case 'too-many-requests':
        return const AppException.tooManyRequest();
      case 'wrong-password':
        return const AppException.wrongPassword();
      default:
        return const AppException.userNotFound();
    }
  }
}
