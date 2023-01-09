import 'package:flutter/material.dart';

void showSnackBar({
  required String message,
  required BuildContext context,
  Color backgroundColor = Colors.black,
  Duration duration = const Duration(milliseconds: 4000),
}) {
  SnackBar snackBar = SnackBar(
    content: Text(message),
    backgroundColor: backgroundColor,
    duration: duration,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
