import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_local_market/components/button.dart';
import 'package:my_local_market/components/future_builder.dart';
import 'package:my_local_market/components/iconbutton.dart';
import 'package:my_local_market/components/imageview.dart';
import 'package:my_local_market/components/sizedbox.dart';
import 'package:my_local_market/components/text.dart';
import 'package:my_local_market/components/textfield.dart';
import 'package:my_local_market/logger/logger.dart';
import 'package:my_local_market/login_controller/login_controller.dart';
import 'package:my_local_market/navigator/navigator.dart';
import 'package:my_local_market/utils/datavalidator.dart';
import 'package:my_local_market/values/constants.dart';
import 'package:my_local_market/values/strings.dart';

import '../../utils/phoneNumberUtils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = "+91";
  String _selectedGender = "";
  late Future<String> _profileImageFuture;
  late User? user;
  bool _isValidPhone = false;
  bool _enableSubmitButton = false;

  @override
  void initState() {
    super.initState();
    print("Init state of profile page");
    _nameController.addListener(getName);
    _emailController.addListener(getEmail);
    _phoneController.addListener(getPhone);
    _profileImageFuture = _getProfileImageUrl();
    user = _getUser();
    if(user != null){
      String? displayName = user!.displayName;
      _nameController.text = displayName ?? "";
      String? email = user!.email;
      _emailController.text = email ?? "";
      Map<String, String>? phoneAndCode = Countries.seperatePhoneAndDialCode(user!.phoneNumber);
      if(phoneAndCode != null){
        _selectedCountryCode = phoneAndCode[AppStrings.country_code]!;
        _phoneController.text = phoneAndCode[AppStrings.phone_without_code]!;
      }
    }

  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build state of profile page");

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        actions: [
          Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
              child: RwIconButton(
                icon: Icons.close_rounded,
                onTap: () {
                  RwNavigator.pop(context: context);
                },
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Constants.base_padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RwFutureBuilder(
                future: _profileImageFuture,
                final_widget: (String data) {
                  return RwNetworkImageView(
                    radius: 64.0,
                    imageUrl: data,
                    onTap: _onProfileIconTap,
                  );
                },
                initial_widget: RwAssetImageView(
                  imagePath: StaticImages.profile_placeholder,
                  onTap: _onProfileIconTap,
                ),
              ),
              RwDividerLine(
                height: Constants.sized_box_base_height,
              ),
              RwTextField(
                controller: _nameController,
                hintText: AppStrings.enter_name,
                label: AppStrings.name,
              ),

              RwTextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: AppStrings.enter_email,
                label: AppStrings.email,
              ),
              RwPhoneNumberField(
                selectedCountryCode: _selectedCountryCode,
                onChangeCountryCode: _onChangeCountryCode,
                onChangeText: _onChangePhoneNumber,
                isValid: _isValidPhone,
              ),
               RwText(
                text: AppStrings.select_gender,
              ),
              Row(
                children: [
                  _getGenderWidget(AppStrings.male, _onMaleGenderSelected, _selectedGender == AppStrings.male),
                  _getGenderWidget(AppStrings.female, _onFemaleGenderSelected, _selectedGender == AppStrings.female),
                  _getGenderWidget(AppStrings.other, _onOtherGenderSelected, _selectedGender == AppStrings.other),
                ],
              ),
              RwDividerLine(
                height: Constants.sized_box_base_height,
              ),
              Row(
                children: [
                  Expanded(child: RwButton(text: AppStrings.submit, enabled: _enableSubmitButton, onPressed: _onSubmit)),
                  const SizedBox(
                    width: Constants.sized_box_base_width,
                  ),
                  Expanded(child: RwButton(text: AppStrings.skip, onPressed: _onSkip)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onSkip() {

  }

  void _onSubmit() {

  }

  User? _getUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Widget _getGenderWidget(gender, onTap, isSelected) {
    IconData icon = Icons.close_rounded;
    if (gender == AppStrings.male) {
      icon = Icons.male_outlined;
    }
    if (gender == AppStrings.female) {
      icon = Icons.female_outlined;
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(Constants.base_padding),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: isSelected ? Colors.blue : Colors.blueGrey, width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: <Widget>[
              Text(
                gender,
                style: TextStyle(color: isSelected ? Colors.blue : Colors.blueGrey),
              ),
              const SizedBox(
                height: Constants.sized_box_base_height,
              ),
              RwIconButton(
                icon: icon,
                onTap: onTap,
                color: isSelected ? Colors.blue : Colors.blueGrey,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onMaleGenderSelected() {
    setState(() {
      _selectedGender = AppStrings.male;
    });
  }

  void _onFemaleGenderSelected() {
    setState(() {
      _selectedGender = AppStrings.female;
    });
  }

  void _onOtherGenderSelected() {
    setState(() {
      _selectedGender = AppStrings.other;
    });
  }

  void _onProfileIconTap() {
    print("on tap profile");
  }

  void _onChangeCountryCode(code) {
    print("Country code: $code");
    setState(() {
      _selectedCountryCode = code;
    });
  }

  Future<String> _getProfileImageUrl() async {
    return await Future.delayed(Duration(seconds: 5), () {
      return "https://4.img-dpreview.com/files/p/E~TS590x0~articles/3925134721/0266554465.jpeg";
      // throw Exception("Custom Error");
    });
  }

  void onSubmitForm(String? name) {
    if (name != null) {
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

  String getName() {
    String name = _nameController.text;
    print("Name $name");
    return name;
  }

  String getEmail() {
    String email = _emailController.text;
    print("Email $email");
    return email;
  }

  String getPhone() {
    String phone = _phoneController.text;
    print("Phone $phone");
    return phone;
  }

  _onChangePhoneNumber(phone) {
    setState(() {
      _isValidPhone = Validator.isValidPhoneNumber(phone);
      _enableSubmitButton = _isValidPhone;
    });
  }
}
