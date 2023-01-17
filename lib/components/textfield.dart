import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_local_market/utils/phoneNumberUtils.dart';
import 'package:my_local_market/values/constants.dart';
import 'package:my_local_market/values/strings.dart';

import '../logger/logger.dart';

class RwTextField extends StatelessWidget {
  Function(String)? onChange;
  TextInputType? keyboardType;
  String? hintText;
  String? label;
  bool? isObscureText;
  bool isValid;
  String? invalidMsg;
  TextEditingController? controller;
  bool enabled;
  Widget? prefixIcon;
  String? prefixText;
  Function(bool)? isValidInput;
  FocusNode? focusNode;
  Function(String)? onSubmitted;
  int? maxLength;
  List<TextInputFormatter>? inputFormatter;

  RwTextField({
    super.key,
    this.onChange,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.label,
    this.isObscureText = false,
    this.isValid = true,
    this.invalidMsg,
    this.controller,
    this.enabled = true,
    this.prefixIcon,
    this.prefixText,
    this.isValidInput,
    this.focusNode,
    this.onSubmitted,
    this.maxLength,
    this.inputFormatter,
  });



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.base_padding),
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          0,
          Constants.base_margin,
          0,
          Constants.base_margin,
        ),
        child: TextField(
          inputFormatters: inputFormatter,
          maxLength: maxLength,
          onSubmitted: onSubmitted,
          focusNode: focusNode,
          controller: controller,
          onChanged: onChange,
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
              borderSide: BorderSide(width: 2, color: Colors.black),
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
      ),
    );
  }
}

class RwPhoneNumberField extends StatefulWidget {
  String selectedCountryCode;
  Function(Object?) onChangeCountryCode;
  Function(String?)? onChangeText;
  TextEditingController? controller;
  bool isValid;
  FocusNode? focusNode;

  RwPhoneNumberField({
    Key? key,
    required this.selectedCountryCode,
    required this.onChangeCountryCode,
    this.onChangeText,
    this.controller,
    this.isValid = false,
    this.focusNode,
  }) : super(key: key);

  @override
  State<RwPhoneNumberField> createState() => _RwPhoneNumberFieldState();
}

class _RwPhoneNumberFieldState extends State<RwPhoneNumberField> {
  final List<String> _countryCodes = Countries.allCountryCode.map((e) => e['dial_code']!).toList();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget countryCodeWidget = DropdownButtonHideUnderline(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton(
          value: widget.selectedCountryCode,
          items: _countryCodes.map((String value) {
            return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 12.0),
                ));
          }).toList(),
          onChanged: widget.onChangeCountryCode,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
    return RwTextField(
      inputFormatter: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
      focusNode: widget.focusNode,
      prefixIcon: countryCodeWidget,
      onChange: widget.onChangeText,
      isValid: widget.isValid,
      controller: widget.controller,
      keyboardType: TextInputType.number,
      hintText: AppStrings.enter_phone,
      label: AppStrings.phone_number,
    );
  }

}
