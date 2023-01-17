import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_local_market/components/button.dart';
import 'package:my_local_market/components/text.dart';
import 'package:my_local_market/components/textfield.dart';
import 'package:my_local_market/login_controller/login_controller.dart';
import 'package:my_local_market/login_controller/login_data_listener.dart';
import 'package:my_local_market/login_controller/login_providers.dart';
import 'package:my_local_market/utils/datavalidator.dart';
import 'package:my_local_market/utils/phoneNumberUtils.dart';
import 'package:my_local_market/values/app_theme.dart';
import 'package:my_local_market/values/constants.dart';
import 'package:my_local_market/values/strings.dart';

import '../../components/iconbutton.dart';
import '../../components/loaders.dart';
import '../../components/snackbar.dart';
import '../../navigator/navigator.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> implements PhoneLoginStateListener {
  late LoginProviderDetails _loginProviderDetails;
  final int _otpDigitCount = 6;
  late List<String> otpDigitText = [];
  late List<FocusNode> otpNodes = [];
  final String _otpDigitTextKey = "otpDigitText";
  final String _otpNodesKey = "otpNodes";
  List<bool> otpFieldEnabled = [true, false, false, false, false, false];
  late Future<Map<String, List<Object>>> _otpFieldsFuture;
  final LoginController _loginController = LoginController();
  bool _isLoaderPresent = false;
  List<Widget> _otpWidgetList = [];
  int _timerText = Constants.otpTimeout;
  bool _enableButton = false;
  bool _enableResendOtp = false;
  bool _hasError = false;
  String _errorText = "";
  String _verificationCode = "";
  Timer? _timer;
  bool _showResendText = false;

  @override
  void initState() {
    super.initState();
    _otpFieldsFuture = _initOTPFields();
    _otpWidgetList = _getOtpWidgetList();
    //_timer = _startOtpTime();
    initPhoneAuthOtp();
  }

  Timer? _startOtpTime() {
    return Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timerText = Constants.otpTimeout - timer.tick;
      });
      if (_timerText == 0) {
        print('Cancel timer');
        timer.cancel();
        setState(() {
          _timerText;
          _enableResendOtp = true;
          //_enableButton = false;
          _showResendText = true;
          _hasError = true;
          _errorText = AppStrings.otp_timeout;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context) != null) {
      _loginProviderDetails = ModalRoute.of(context)!.settings.arguments as LoginProviderDetails;
    }
  }

  List<Widget> _getOtpWidgetList() {
    List<Widget> list = [];
    for (var index = 0; index < _otpDigitCount; index++) {
      list.add(
        Expanded(
          child: RwTextField(
              inputFormatter: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1),],
              //maxLength: 1,
              focusNode: otpNodes[index],
              //enabled: otpFieldEnabled[index],
              onChange: (digit) {
                if (digit.isNotEmpty) {
                  otpDigitText[index] = digit;
                  if (index < _otpDigitCount - 1) {
                    print("Will shift focus to ${index + 1}");
                    otpNodes[index].unfocus();
                    FocusScope.of(context).requestFocus(otpNodes[index + 1]);
                    otpFieldEnabled[index] = false;
                    otpFieldEnabled[index + 1] = true;
                  } else {
                    otpNodes[index].unfocus();
                    setState(() {
                      _enableButton = true;
                    });
                  }
                } else {
                  otpDigitText[index] = "";
                  if (index > 0) {
                    print("Will shift focus to ${index - 1}");
                    otpNodes[index].unfocus();
                    FocusScope.of(context).requestFocus(otpNodes[index - 1]);
                    otpFieldEnabled[index] = false;
                    otpFieldEnabled[index - 1] = true;
                    setState(() {
                      _enableButton = false;
                    });
                  } else {
                    otpNodes[index].unfocus();
                  }
                }
              },
              keyboardType: TextInputType.number),
        ),
      );
    }
    return list;
  }

  Future<Map<String, List<Object>>> _initOTPFields() async {
    Map<String, List<Object>> otpVariables = {};
    await Future.forEach([0, 1, 2, 3, 4, 5, 6], (element) {
      otpDigitText.add("");
      otpNodes.add(FocusNode());
    });
    otpVariables[_otpDigitTextKey] = otpDigitText;
    otpVariables[_otpNodesKey] = otpNodes;
    return await Future(() => otpVariables);
  }

  @override
  void dispose() {
    // Clean up the controller and focus nodes when the widget is removed from the widget tree.
    for (var i = 0; i >= _otpDigitCount; i++) {
      otpNodes[i].dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(
          child: RwIconButton(
            icon: Icons.close_rounded,
            onTap: () {
              RwNavigator.pop(context: context);
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Constants.base_padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RwText(
              text: AppStrings.otp_verification,
              textStyle: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(
              height: Constants.sized_box_base_height,
            ),
            RwText(
              text: "${AppStrings.otp_verify_info}${_loginProviderDetails.loginParameter}",
            ),
            SizedBox(
              height: 100.0,
              child: FutureBuilder(
                future: _otpFieldsFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print("Snapshot: ${snapshot.data}");
                    otpNodes = snapshot.data![_otpNodesKey] as List<FocusNode>;
                    otpDigitText = snapshot.data![_otpDigitTextKey] as List<String>;

                    return Row(
                      children: _otpWidgetList,
                    );
                  }
                  return const SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            if (_hasError)
              RwText(
                text: _errorText,
                color: WidgetColors.error_text,
              ),
            const SizedBox(
              height: Constants.sized_box_seperator_height,
            ),
            Row(
              children: [
                Expanded(
                  child: RwButton(
                    text: AppStrings.login,
                    onPressed: initLogin,
                    enabled: _enableButton,
                  ),
                ),
                const SizedBox(
                  width: Constants.sized_box_base_width * 4,
                ),
                Expanded(
                  child: Column(
                    children: [
                      RwText(
                        text: "${AppStrings.remaining_time} : $_timerText",
                      ),
                      const SizedBox(
                        height: Constants.sized_box_base_height,
                      ),
                      if (_showResendText)
                        GestureDetector(
                          onTap: resendOtp,
                          child: RwText(
                            text: AppStrings.resend_otp,
                            color: _enableResendOtp ? WidgetColors.enabled_text : WidgetColors.disabled_text,
                            textStyle:
                                themeData_light.textTheme.bodyText1?.copyWith(decoration: TextDecoration.underline),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }


  void initPhoneAuthOtp() {
    Map<String, String>? phoneAndCode = Countries.seperatePhoneAndDialCode(_loginProviderDetails.loginParameter);
    print(
        "Code is ${phoneAndCode![AppStrings.country_code]} and phone is ${phoneAndCode[AppStrings
            .phone_without_code]}");
    String? phone = phoneAndCode[AppStrings.phone_without_code];
    if (phone != null) {
      if (Validator.isValidPhoneNumber(phone)) {
        print("Phone is correct $phone");
        setState(() {
          _hasError = false;
        });
        toggleLoaderDialog(context: context, isLoaderPresent: _isLoaderPresent, loaderInfo: AppStrings.please_wait);
        _isLoaderPresent = !_isLoaderPresent;
        _loginController.initLoginWithPhone(this, _loginProviderDetails.loginParameter);
      }
    }
  }

  void resendOtp() {
    if (_enableResendOtp) {
      print("Resending otp");
      initPhoneAuthOtp();
      } else {
        setState(() {
          _hasError = true;
          _errorText = AppStrings.something_wrong;
        });
      }
    }

  void initLogin() async {
    toggleLoaderDialog(context: context, isLoaderPresent: _isLoaderPresent, loaderInfo: AppStrings.please_wait);
    _isLoaderPresent = !_isLoaderPresent;
    print("Will login");
    String smsCode = "";
    await Future.forEach(otpDigitText, (digit) {
      smsCode = "$smsCode$digit";
    });
    print("Sms code $smsCode");
    print("Verification code $_verificationCode");
    _loginController.signInWithCredential(this, _verificationCode, smsCode);
  }

  @override
  codeAutoRetrievalTimeout(String verificationId) {
    print("Code timeout");
  }

  @override
  codeSent(String verificationId, int? resendToken) {
    toggleLoaderDialog(context: context, isLoaderPresent: _isLoaderPresent, loaderInfo: AppStrings.please_wait);
    _isLoaderPresent = !_isLoaderPresent;
    _verificationCode = verificationId;
    setState(() {
      _showResendText = false;
      _hasError = false;
      _timer = _startOtpTime();
    });
    print("Code sent");
  }

  @override
  verificationCompleted(PhoneAuthCredential phoneAuthCredential) {
    toggleLoaderDialog(context: context, isLoaderPresent: _isLoaderPresent, loaderInfo: AppStrings.please_wait);
    _isLoaderPresent = !_isLoaderPresent;
    print("Login successful");
    User? user = FirebaseAuth.instance.currentUser;
    print("Current user: $user");
    toggleLoaderDialog(context: context, isLoaderPresent: _isLoaderPresent, loaderInfo: AppStrings.please_wait);
    _isLoaderPresent = !_isLoaderPresent;
    if (user != null) {
      RwNavigator.goToProfileRegistration(
          context: context, sourceScreen: ScreenName.phoneLoginScreen, user: user);
    } else {
      showSnackBar(message: AppStrings.firebase_user_error, context: context);
    }
  }

  @override
  verificationFailed(FirebaseAuthException e) {
    print("Login failed ${e.message}");
    toggleLoaderDialog(context: context, isLoaderPresent: _isLoaderPresent, loaderInfo: AppStrings.please_wait);
    _isLoaderPresent = !_isLoaderPresent;
    String errorCode = e.code;
    setState(() {
      _hasError = true;
      print("Exception message showing as ${e.message}");
      if (errorCode == RwAuthConstant.invalid_verification_code) {
        _errorText = AppStrings.incorrect_otp;
      } else {
        _errorText = AppStrings.something_wrong;
      }
    });
  }
}
