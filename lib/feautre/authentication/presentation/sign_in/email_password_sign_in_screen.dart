 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solution_challenge_project/core/common_widgets/async_value_ui.dart';
import 'package:solution_challenge_project/core/common_widgets/custom_text_button.dart';
import 'package:solution_challenge_project/core/common_widgets/primary_button.dart';
import 'package:solution_challenge_project/core/common_widgets/responsive_scrollable_card.dart';
import 'package:solution_challenge_project/core/constants/app_sizes.dart';
import 'package:solution_challenge_project/feautre/authentication/presentation/sign_in/string_validators.dart';
 
 
import 'email_password_sign_in_controller.dart';
import 'email_password_sign_in_form_type.dart';
import 'email_password_sign_in_validators.dart';

class EmailPasswordSignInScreen extends ConsumerWidget {
  final EmailPasswordSignInFormType formType;
  const EmailPasswordSignInScreen({
    super.key,
    required this.formType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(middle: Text('Sign In')),
      body: EmailPasswordSignInContents(
        formType: formType,
      ),
    );
  }
}

class EmailPasswordSignInContents extends ConsumerStatefulWidget {
  const EmailPasswordSignInContents({
    super.key,
    this.onSignedIn,
    required this.formType,
  });
  final VoidCallback? onSignedIn;

  final EmailPasswordSignInFormType formType;
  @override
  ConsumerState<EmailPasswordSignInContents> createState() =>
      _EmailPasswordSignInContentsState();
}

class _EmailPasswordSignInContentsState
    extends ConsumerState<EmailPasswordSignInContents>
    with EmailAndPasswordValidators {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get email => _emailController.text;
  String get password => _passwordController.text;

  var _submitted = false;
  late var _formType = widget.formType;

  @override
  void dispose() {
    _node.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    // only submit the form if validation passes
    if (_formKey.currentState!.validate()) {
      final controller =
          ref.read(emailPasswordSignInControllerProvider.notifier);
      final success = await controller.submit(
        email: email,
        password: password,
        formType: _formType,
      );
      if (success) {
        widget.onSignedIn?.call();
      }
    }
  }

  void _emailEditingComplete() {
    if (canSubmitEmail(email)) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete() {
    if (!canSubmitEmail(email)) {
      _node.previousFocus();
      return;
    }
    _submit();
  }

  void _updateFormType() {
    setState(() => _formType = _formType.secondaryActionFormType);
    _submitted = false;
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      emailPasswordSignInControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(emailPasswordSignInControllerProvider);
    return Center(
      child: ResponsiveScrollableCard(
        child: FocusScope(
          node: _node,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                gapH8,
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'test@test.com',
                    enabled: !state.isLoading,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      !_submitted ? null : emailErrorText(email ?? ''),
                  autocorrect: false,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  keyboardAppearance: Brightness.light,
                  onEditingComplete: () => _emailEditingComplete(),
                  inputFormatters: <TextInputFormatter>[
                    ValidatorInputFormatter(
                        editingValidator: EmailEditingRegexValidator()),
                  ],
                ),
                gapH8,
                // Password field
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: _formType.passwordLabelText,
                    enabled: !state.isLoading,
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (password) => !_submitted
                      ? null
                      : passwordErrorText(password ?? '', _formType),
                  obscureText: true,
                  autocorrect: false,
                  textInputAction: TextInputAction.done,
                  keyboardAppearance: Brightness.light,
                  onEditingComplete: () => _passwordEditingComplete(),
                ),
                gapH8,
                PrimaryButton(
                  text: _formType.primaryButtonText,
                  isLoading: state.isLoading,
                  onPressed: state.isLoading ? null : () => _submit(),
                ),
                gapH8,
                CustomTextButton(
                  text: _formType.secondaryButtonText,
                  onPressed: state.isLoading ? null : _updateFormType,
                ),
    
                //Todo: Sign with apple button
                //Todo: Sign with google button
              ],
            ),
          ),
        ),
      ),
    );
  }
}
