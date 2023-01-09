import 'package:flutter/material.dart';
import 'package:my_local_market/values/constants.dart';

class RwTextField extends StatelessWidget {
  final Function onChange;
  TextInputType keyboardType;
  String? hintText;
  String? label;
  bool? isObscureText;
  bool isValid;
  String? invalidMsg;
  TextEditingController? controller;
  bool enabled;
  Widget? prefixIcon;
  String? prefixText;



  RwTextField({super.key,
    required this.onChange,
    required this.keyboardType,
    this.hintText,
    this.label,
    this.isObscureText = false,
    this.isValid = true,
    this.invalidMsg,
    this.controller,
    this.enabled = true,
    this.prefixIcon,
    this.prefixText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        0,
        Constants.base_margin,
        0,
        Constants.base_margin,
      ),
      child: TextField(
        controller: controller,
        onChanged: (text) {
          onChange(text);
        },
        enabled: enabled,
        obscureText: isObscureText ?? false,
        style: enabled ? null : const TextStyle(color: Colors.grey),
        textAlign: TextAlign.left,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          prefixText: prefixText,
          labelText: label,
          errorText: isValid ? null : invalidMsg,
          errorStyle: const TextStyle(color: Colors.red),
          labelStyle: const TextStyle(color: Colors.red),
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.red),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width:2, color: Colors.black),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.grey),
          ),
          hintText: hintText ?? "",
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          contentPadding: const EdgeInsets.all(
            Constants.base_margin,
          ),
        ),
      ),
    );
  }
}
