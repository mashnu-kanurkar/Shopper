import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_local_market/components/button.dart';
import 'package:my_local_market/components/text.dart';
import 'package:my_local_market/components/textfield.dart';
import 'package:my_local_market/logger/logger.dart';
import 'package:my_local_market/login_controller/login_controller.dart';
import 'package:my_local_market/login_controller/login_data_listener.dart';
import 'package:my_local_market/values/constants.dart';
import 'package:my_local_market/values/strings.dart';

import '../../components/loaders.dart';
import '../../components/snackbar.dart';
import '../../navigator/navigator.dart';
import '../../values/screen_names.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({Key? key}) : super(key: key);

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> implements PhoneLoginStateListener {
  bool _showOTPField = false;
  String _digit1 = "";
  String _digit2 = "";
  String _digit3 = "";
  String _digit4 = "";
  String _digit5 = "";
  String _digit6 = "";
  bool _isValidPhone = true;
  bool _isLoaderPresent = false;
  late bool _enableButton;
  final List<String> _countryCodes = ['+91', '+1'];
  String? _selectedCountryCode;

  String _buttonText = AppStrings.get_otp;

  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneNumberController.addListener(_getPhoneNumber);
    _enableButton = _getPhoneNumber().length >= 10;
    _selectedCountryCode = _countryCodes.first;
  }

  @override
  Widget build(BuildContext context) {
    Widget countryCodeWidget = DropdownButtonHideUnderline(
      child: ButtonTheme(
          alignedDropdown: true,
        child: DropdownButton(
          value: _selectedCountryCode,
          items: _countryCodes.map((String value) {
            return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 12.0),
                ));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCountryCode = value!;
            });
          },
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(Constants.base_margin),
          child: Column(
            children: <Widget>[
              const Icon(
                Icons.phone,
                size: 80.0,
              ),
              RwText(
                text: _showOTPField ? AppStrings.verify_otp : AppStrings.enter_phone,
                textStyle: Theme.of(context).textTheme.headline1,
              ),
              const SizedBox(
                height: Constants.sized_box_base_height,
              ),
              RwText(text: _showOTPField ? AppStrings.enter_otp : AppStrings.otp_info),
              const SizedBox(
                height: Constants.sized_box_base_height,
              ),
              RwTextField(
                prefixIcon: countryCodeWidget,
                onChange: (text) {
                  Logger.log(LogLevel.DEBUG, text, StackTrace.current);
                  if (text.length >= 10) {
                    setState(() {
                      _enableButton = true;
                    });
                  }else{
                    setState(() {
                      _enableButton = false;
                    });
                  }
                },
                isValid: _isValidPhone,
                controller: _phoneNumberController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: Constants.sized_box_base_height,
              ),
              if (_showOTPField)
                Row(
                  children: <Widget>[
                    RwTextField(
                        onChange: (digit1) {
                          _digit1 = digit1;
                          Focus.of(context).nextFocus();
                        },
                        keyboardType: TextInputType.number),
                    RwTextField(
                        onChange: (digit2) {
                          _digit2 = digit2;
                          Focus.of(context).nextFocus();
                        },
                        keyboardType: TextInputType.number),
                    RwTextField(
                        onChange: (digit3) {
                          _digit3 = digit3;
                          Focus.of(context).nextFocus();
                        },
                        keyboardType: TextInputType.number),
                    RwTextField(
                        onChange: (digit4) {
                          _digit4 = digit4;
                          Focus.of(context).nextFocus();
                        },
                        keyboardType: TextInputType.number),
                    RwTextField(
                        onChange: (digit5) {
                          _digit5 = digit5;
                          Focus.of(context).nextFocus();
                        },
                        keyboardType: TextInputType.number),
                    RwTextField(
                        onChange: (digit6) {
                          _digit6 = digit6;
                          Focus.of(context).unfocus();
                        },
                        keyboardType: TextInputType.number)
                  ],
                ),
              RwButton(
                enabled: _enableButton,
                text: _buttonText,
                onPressed: initLoginWithPhone,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initLoginWithPhone() {
    if (_getPhoneNumber().length < 10) {
      _isValidPhone = false;
    } else {
      toggleLoaderDialog(context: context, isLoaderPresent: _isLoaderPresent, loaderInfo: AppStrings.please_wait);
      _isLoaderPresent = !_isLoaderPresent;
      LoginController loginController = LoginController();
      loginController.initLoginWithPhone(this, _getPhoneNumber());
    }
  }

  String _getPhoneNumber() {
    return "$_selectedCountryCode${_phoneNumberController.text}";
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  codeAutoRetrievalTimeout(String verificationId) {
    // TODO: implement codeAutoRetrievalTimeout
    throw UnimplementedError();
  }

  @override
  codeSent(String verificationId, int? resendToken) {
    //code has been sent. Dismiss loader and let user enter otp.
    Logger.log(LogLevel.DEBUG, "Verification ID $verificationId and resendToken $resendToken", StackTrace.current);
    setState(() {
      toggleLoaderDialog(context: context, isLoaderPresent: _isLoaderPresent);
      _isLoaderPresent = !_isLoaderPresent;
      _showOTPField = true;
      _buttonText = AppStrings.verify_otp;
    });
  }

  @override
  verificationCompleted(PhoneAuthCredential phoneAuthCredential) {
    Logger.log(LogLevel.DEBUG, "PhoneAuthCreds: $phoneAuthCredential", StackTrace.current);
    setState(() {
      toggleLoaderDialog(context: context, isLoaderPresent: _isLoaderPresent);
      _isLoaderPresent = !_isLoaderPresent;

    });
    User? user = FirebaseAuth.instance.currentUser;
    showSnackBar(message: AppStrings.login_success, context: context, backgroundColor: Colors.green);
    if (user?.displayName == null || user?.displayName == "") {
      print("User display name is null");
      RwNavigator.goToProfileRegistration(context: context, sourceScreen: ScreenName.loginScreen, user: user);
    } else {
      print("User display name is ${user?.displayName}");
      RwNavigator.next(context: context, sourceScreen: ScreenName.phoneLoginScreen, destination: ScreenName.homeScreen);
    }
  }

  @override
  verificationFailed(FirebaseAuthException e) {
    Logger.log(LogLevel.ERROR, e.toString(), StackTrace.current);
  }
}
