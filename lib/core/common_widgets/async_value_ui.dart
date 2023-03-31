import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';
import 'package:solution_challenge_project/core/common_widgets/alert_dialogs.dart';
import 'package:solution_challenge_project/core/exceptions/app_exception.dart';

extension AsyncValueUI on AsyncValue {
  
  void showScaffoldErrorMessage(BuildContext context, String text) {
    when(
        data: (a) {},
        error: (a, b) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(text),
                backgroundColor: context.colorScheme.error,
              ));
            });
          });
        },
        loading: () {});
  }

  void showAlertDialogOnError(BuildContext context) {
    if (!isLoading && hasError) {
      final message = _errorMessage(error);
      showExceptionAlertDialog(
        context: context,
        title: 'Error',
        exception: message,
      );
    }
   
  }

  String _errorMessage(Object? error) {
    if (error is AppException) {
      return error.details.message;
    } else {
      return error.toString();
    }
  }
}
