import 'package:flutter/material.dart';

class AddressEditor extends StatefulWidget {
  const AddressEditor({Key? key}) : super(key: key);

  @override
  State<AddressEditor> createState() => _AddressEditorState();
}

class _AddressEditorState extends State<AddressEditor> {
  TextEditingController _addressLine1Controller = TextEditingController();
  TextEditingController _addressLine2Controller = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
