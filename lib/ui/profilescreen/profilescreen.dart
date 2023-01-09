import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_local_market/components/button.dart';
import 'package:my_local_market/components/textfield.dart';
import 'package:my_local_market/login_controller/login_controller.dart';
import 'package:my_local_market/values/strings.dart';

class ProfileScreen extends StatefulWidget {
  late User _user;
  ProfileScreen({required User user}) {
    _user = user;
  }

  @override
  State<ProfileScreen> createState() => _ProfileScreenState(_user!);
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User _user;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  String? _name;

  _ProfileScreenState(User user) {
    _user = user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.profile),
      ),
      body: Column(
        children: <Widget>[
          RwTextField(
            onChange: (text) {
              onNameChange(text);
            },
            controller: _nameController,
            keyboardType: TextInputType.text,
            label: AppStrings.name,
            hintText: AppStrings.enter_name,
          ),
          RwTextField(
            onChange: (text) {
              onEmailChange(text);
            },
            controller: _emailController,
            keyboardType: TextInputType.text,
            label: AppStrings.email,
            hintText: AppStrings.enter_email,
            enabled: !hasEmail(_user!),
          ),
          RwTextField(
            onChange: (text) {
              onPhoneChange(text);
            },
            controller: _phoneController,
            keyboardType: TextInputType.text,
            label: AppStrings.phone_number,
            hintText: AppStrings.enter_phone,
            enabled: !hasPhone(_user!),
          ),
          RwButton(text: AppStrings.submit, onPressed: (){
            onSubmitForm(_name);
          }),
        ],
      ),
    );
  }

  void onSubmitForm(String? name){
    if(name != null){
      LoginController loginController = LoginController();
      loginController.updateDisplayName(name: name);
    }

  }

  bool hasEmail(User user) {
    String? email = user.email;
    if (email != null) {
      _emailController.text = email;
      return true;
    } else {
      return false;
    }
  }

  bool hasPhone(User user) {
    String? phoneNumber = user.phoneNumber;
    if (phoneNumber != null) {
      _phoneController.text = phoneNumber;
      return true;
    } else {
      return false;
    }
  }

  void onNameChange(String name) {
    print("Name $name");
    _name = name;
  }

  void onEmailChange(String email) {
    print("Email $email");
  }

  void onPhoneChange(String phone) {
    print("Phone $phone");

  }
}
