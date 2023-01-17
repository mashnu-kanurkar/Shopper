import 'package:flutter/material.dart';
import 'package:my_local_market/values/constants.dart';

void showSnackBar({
  required String message,
  required BuildContext context,
  Color backgroundColor = WidgetColors.snackbar_bg,
  Duration duration = const Duration(milliseconds: 4000),
}) {
  SnackBar snackBar = SnackBar(
    content: Text(message),
    backgroundColor: backgroundColor,
    duration: duration,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.0))),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
