import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final alertDialogProvider = Provider<AlertDialog>((ref) => AlertDialog(ref));

class AlertDialog {
  AlertDialog(this.ref);

  final Ref ref;

  int _numberOfShowedAlertDialogs = 0;

  Future<void> showAlertDialog({
    required BuildContext context,
    required Widget dialog,
    bool barrierDismissible = false,
  }) async {
    while (_numberOfShowedAlertDialogs > 0) {
      _numberOfShowedAlertDialogs--;
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }

    _numberOfShowedAlertDialogs++;
    await showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }
}
