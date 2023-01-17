import 'package:flutter/material.dart';
import 'package:my_local_market/components/button.dart';
import 'package:my_local_market/components/text.dart';
import 'package:my_local_market/components/textfield.dart';
import 'package:my_local_market/login_controller/login_providers.dart';
import 'package:my_local_market/utils/datavalidator.dart';
import 'package:my_local_market/values/constants.dart';
import 'package:my_local_market/values/strings.dart';

import '../../components/iconbutton.dart';
import '../../navigator/navigator.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({Key? key}) : super(key: key);

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  late String _phoneWithCode = "";
  late bool _enableButton;
  String _selectedCountryCode = "+91";
  String _buttonText = AppStrings.get_otp;
  bool _isValidPhone = false;

  final TextEditingController _phoneNumberController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _phoneNumberController.addListener(_getPhoneNumber);
    _enableButton = _getPhoneNumber().length >= 10;
    _selectedCountryCode = "+91";
    //FirebaseAuth.instance.useAuthEmulator("http://localhost", 9099);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
              child: RwIconButton(
                icon: Icons.arrow_back,
                onTap: () {
                  RwNavigator.pop(context: context);
                },
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(Constants.base_padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.phone,
                size: 80.0,
              ),
              RwText(
                text: AppStrings.enter_phone,
                textStyle: Theme.of(context).textTheme.headline1,
              ),
              const SizedBox(
                height: Constants.sized_box_seperator_height,
              ),
              RwText(text: AppStrings.otp_info),
              const SizedBox(
                height: Constants.sized_box_seperator_height,
              ),
              RwPhoneNumberField(
                focusNode: _phoneFocusNode,
                controller: _phoneNumberController,
                selectedCountryCode: _selectedCountryCode,
                onChangeCountryCode: _onChangeCountryCode,
                onChangeText: _onChangePhoneNumber,
                isValid: _isValidPhone,
              ),
              const SizedBox(
                height: Constants.sized_box_seperator_height,
              ),
              //if (_showOTPField)
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

  void _onChangePhoneNumber(text) {
    setState(() {
      print("$text");
      _isValidPhone = Validator.isValidPhoneNumber(text);
      _enableButton = _isValidPhone;
      if(_isValidPhone){
        _phoneFocusNode.unfocus();
      }
    });
  }

  void _onChangeCountryCode(code) {
    setState(() {
      _selectedCountryCode = code as String;
    });
  }

  void initLoginWithPhone() async {
    if(_isValidPhone){
      RwNavigator.next(context: context, sourceScreen: ScreenName.phoneLoginScreen, destination: ScreenName.otpScreen, arguments: LoginProviderDetails(LoginProvider.phone, _phoneWithCode, null));
    }
  }

  String _getPhoneNumber() {
    print(_phoneNumberController.text);
    _phoneWithCode =  "$_selectedCountryCode${_phoneNumberController.text}";
    return _phoneWithCode;
  }
}
