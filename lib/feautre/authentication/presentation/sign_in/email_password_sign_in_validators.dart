 
 import 'package:solution_challenge_project/feautre/authentication/presentation/sign_in/string_validators.dart';

import 'email_password_sign_in_form_type.dart';

mixin EmailAndPasswordValidators {
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator passwordRegisterSubmitValidator =
      MinLengthStringValidator(8);

  bool canSubmitEmail(String email) => emailSubmitValidator.isValid(email);

  bool canSubmitPassword(String password) =>
      passwordRegisterSubmitValidator.isValid(password);

  String? emailErrorText(String email) {
    final bool showErrorText = !canSubmitEmail(email);
    final String errorText = email.isEmpty
        ? 'Email can\'t be empty'
        : 'Invalid email';
    return showErrorText ? errorText : null;
  }

  String? passwordErrorText(
      String password, EmailPasswordSignInFormType formType) {
    final bool showErrorText = !canSubmitPassword(password);
    final String errorText = password.isEmpty
        ? 'Password can\'t be empty'
        : 'Password is too short';
    return showErrorText ? errorText : null;
  }
}
