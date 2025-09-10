import 'package:flutter/material.dart';
import 'package:myapp/util/exit_alert.dart';

Future<bool> showPopConfirmationDialog(BuildContext context) async {
  final shouldDiscard = await showDialog<bool>(
    context: context,
    builder: (BuildContext dialogContext) {
      return ExitAlert();
    },
  );

  return shouldDiscard ?? false;
}
