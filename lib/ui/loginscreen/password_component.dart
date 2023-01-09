import 'package:flutter/material.dart';
import '../../components/textfield.dart';

Widget passwordField({
  required Function(String) onPasswordChange,
  required String passwordHint,
  required String label,
  required bool isObscureText,
  required Function() onIconPressed,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      Expanded(
        child: RwTextField(
          onChange: (text) {
            onPasswordChange(text);
          },
          keyboardType: TextInputType.text,
          hintText: passwordHint,
          label: label,
          isObscureText: isObscureText,
        ),
      ),
      IconButton(
        onPressed: onIconPressed,
        icon: Icon(
          isObscureText ? Icons.visibility_off : Icons.visibility,
          size: 20.0,
          color: Colors.teal[600],
        ),
      ),
    ],
  );
}

