import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_local_market/components/button.dart';
import 'package:my_local_market/components/snackbar.dart';
import 'package:my_local_market/components/text.dart';
import 'package:my_local_market/components/textfield.dart';
import 'package:my_local_market/login_controller/login_controller.dart';
import 'package:my_local_market/login_controller/login_providers.dart';
import 'package:my_local_market/navigator/navigator.dart';
import 'package:my_local_market/ui/loginscreen/password_component.dart';
import 'package:my_local_market/values/constants.dart';
import 'package:my_local_market/values/screen_names.dart';
import '../../components/loaders.dart';
import '../../login_controller/login_data_listener.dart';
import '../../values/strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> implements PhoneLoginStateListener, EmailLoginStateListener {
  List<RwRadioButtonModel> radioList = [
    RwRadioButtonModel(
      index: 0,
      title: AppStrings.email,
      isSelected: true,
      value: LoginProvider.email,
    ),
    RwRadioButtonModel(
      index: 1,
      title: AppStrings.phone_number,
      isSelected: false,
      value: LoginProvider.phone,
    )
  ];

  String _hintText = AppStrings.enter_email;
  TextInputType _keyboardType = TextInputType.emailAddress;
  String _buttonText = AppStrings.key_continue;
  LoginProvider _loginProvider = LoginProvider.email;
  String? _loginParameter;
  String _password = '';
  String _confirmPassword = '';
  bool _isObscureText = true;
  bool _showPasswordField = false;
  bool _showConfirmPasswordField = false;
  bool _isValid = true;
  String _inValidMsg = '';
  bool _isLoaderPresent = false;
  String _passwordhint = AppStrings.enter_password;
  String _confirmPasswordhint = AppStrings.confirm_password;
  TextEditingController _controller = TextEditingController();

  String? _verificationID;
  String? _smsCode;
  int? _resendToken;
  PhoneAuthCredential? _credential;
  LoginController? _loginController = LoginController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        margin: const EdgeInsets.all(Constants.base_margin),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RwText(
              text: AppStrings.login_info,
              textStyle: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(
              height: 10.0,
            ),
            RwRadioGroup(
                radioButtonModelList: radioList,
                orientation: RwOrientation.HORIZONTAL,
                onChangeSelection: (value, index, isSelected) {
                  print("On change $value and $index and $isSelected");
                  setState(() {
                    FocusScope.of(context).unfocus();
                    _controller.clear();
                    if (!isSelected) {
                      List<RwRadioButtonModel> newRadioList = radioList;
                      for (var element in newRadioList) {
                        if (element.index == index) {
                          element.isSelected = true;
                        } else {
                          element.isSelected = false;
                        }
                      }

                      if (value == LoginProvider.email) {
                        _hintText = AppStrings.enter_email;
                        _keyboardType = TextInputType.emailAddress;
                        _buttonText = AppStrings.key_continue;
                        _loginProvider = LoginProvider.email;
                      }
                      if (value == LoginProvider.phone) {
                        _hintText = AppStrings.enter_phone;
                        _keyboardType = TextInputType.phone;
                        _buttonText = AppStrings.get_otp;
                        _loginProvider = LoginProvider.phone;
                      }
                    }
                  });
                }),
            RwTextField(
              onChange: (text) {
                onTextChange(text);
              },
              controller: _controller,
              keyboardType: _loginProvider == LoginProvider.email ? TextInputType.emailAddress : TextInputType.phone,
              hintText: _hintText,
              isValid: _isValid,
              invalidMsg: _inValidMsg,
            ),
            if (_showPasswordField)
              passwordField(
                onPasswordChange: (text) {
                  onPasswordChange(text);
                },
                passwordHint: AppStrings.enter_password,
                label: AppStrings.password,
                isObscureText: _isObscureText,
                onIconPressed: () {
                  setState(() {
                    _isObscureText = !_isObscureText;
                  });
                },
              ),
            if (_showConfirmPasswordField)
              passwordField(
                onPasswordChange: (text) {
                  onConfirmPasswordChange(text);
                },
                passwordHint: AppStrings.confirm_password,
                label: AppStrings.password,
                isObscureText: _isObscureText,
                onIconPressed: () {
                  setState(() {
                    _isObscureText = !_isObscureText;
                  });
                },
              ),
            RwButton(
              text: _buttonText,
              onPressed: () async {
                print("Buttontext is $_buttonText and Login provider $_loginProvider");
                if (_buttonText == AppStrings.key_continue || _buttonText == AppStrings.get_otp) {
                  if (_loginProvider == LoginProvider.phone) {
                    if (_loginParameter != null && _loginParameter?.length == 10) {
                      String phoneNumber = "+91$_loginParameter";
                      print("Phone number $phoneNumber");
                      //user clicked on get otp
                      toggleLoaderDialog(context: context, isLoaderPresent: _isLoaderPresent, loaderInfo: AppStrings.please_wait);
                      _isLoaderPresent = !_isLoaderPresent;
                      _loginController?.initLoginWithPhone(this, phoneNumber);
                    } else {
                      showErrorLabel(AppStrings.enter_valid_phoe);
                    }
                  } else if (_loginProvider == LoginProvider.email) {
                    if (_loginParameter != null) {
                      final bool emailValid =
                          RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(_loginParameter!);
                      if (emailValid) {
                        print("Email $_loginParameter");
                        toggleLoaderDialog(
                            context: context, isLoaderPresent: _isLoaderPresent, loaderInfo: AppStrings.please_wait);
                        _isLoaderPresent = !_isLoaderPresent;
                        _loginController?.initLoginWithEmail(this, _loginParameter!);
                      } else {
                        showErrorLabel(AppStrings.enter_valid_email);
                      }
                    }else{
                      showErrorLabel(AppStrings.enter_email);
                    }
                  }
                } else if (_buttonText == AppStrings.verify_otp) {
                  if (_verificationID != null && _smsCode != null && _resendToken != null) {
                    toggleLoaderDialog(
                        context: context, isLoaderPresent: _isLoaderPresent, loaderInfo: AppStrings.please_wait);
                    _isLoaderPresent = !_isLoaderPresent;
                    await _loginController?.signInWithCredential(verificationId: _verificationID!, smsCode: _smsCode!);
                    toggleLoaderDialog(
                      context: context,
                      isLoaderPresent: _isLoaderPresent,
                    );
                    User? user = FirebaseAuth.instance.currentUser;
                    print("Current user: $user");
                  }
                } else if (_buttonText == AppStrings.login) {
                  toggleLoaderDialog(
                      context: context, isLoaderPresent: _isLoaderPresent, loaderInfo: AppStrings.please_wait);
                  _isLoaderPresent = !_isLoaderPresent;
                  await _loginController?.signInWithEmailAndPassword(
                      emailLoginStateListener: this, email: _loginParameter!, password: _password!);
                  User? user = FirebaseAuth.instance.currentUser;
                  print("Current user: $user");
                } else if (_buttonText == AppStrings.create_account) {
                  if (_password == _confirmPassword) {
                    _loginController?.createUserWithEmailAndPassword(
                        emailLoginStateListener: this, email: _loginParameter!, password: _password);
                  } else {
                    const snackBar = SnackBar(content: Text('Password mismatch'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
              },
              widthMatchParent: true,
            ),
          ],
        ),
      )),
    );
  }

  void showErrorLabel(String invalidMsg){
    setState(() {
    FocusScope.of(context).unfocus();
    _isValid = false;
    _inValidMsg = invalidMsg;
    });
  }

  void onTextChange(text) {
    _loginParameter = text;
  }

  void onPasswordChange(text) {
    if (_loginProvider == LoginProvider.email) {
      _password = text;
    } else if (_loginProvider == LoginProvider.phone) {
      _smsCode = text;
    }
  }

  void onConfirmPasswordChange(text) {
    if (_loginProvider == LoginProvider.email) {
      _confirmPassword = text;
    }
  }

  @override
  codeAutoRetrievalTimeout(String verificationId) {
    print("codeAutoRetrievalTimeout verificationId $verificationId");
  }

  @override
  codeSent(String verificationId, int? resendToken) {
    print(" verificationId $verificationId and resendToken $resendToken");
    _verificationID = verificationId;
    _resendToken = resendToken;
    setState(() {
      FocusScope.of(context).unfocus();
      //Code has been sent. dismiss loader and let user enter otp
      toggleLoaderDialog(
        context: context,
        isLoaderPresent: _isLoaderPresent,
      );
      _isLoaderPresent = !_isLoaderPresent;
      _passwordhint = AppStrings.enter_otp;
      _showPasswordField = true;
      _buttonText = AppStrings.verify_otp;
    });
  }

  @override
  verificationCompleted(PhoneAuthCredential credential) {
    print("credential $credential");
    User? user = FirebaseAuth.instance.currentUser;
    showSnackBar(message: AppStrings.login_success, context: context, backgroundColor: Colors.green);
    if(user?.displayName == null || user?.displayName == ""){
      print("User display name is null");
      RwNavigator.goToProfileRegistration(context: context, sourceScreen: ScreenName.loginScreen, user: user);
    }else{
      print("User display name is ${user?.displayName}");
      RwNavigator.next(context: context, sourceScreen: ScreenName.loginScreen, destination: ScreenName.homeScreen);
    }
  }

  @override
  verificationFailed(FirebaseAuthException e) {
    print("verificationFailed exception $e");

  }

  @override
  onEmailAuthException(String rwFirebaseAuthException) {
    print("onEmailAuthException rwFirebaseAuthException $rwFirebaseAuthException");
    if (rwFirebaseAuthException == RwAuthConstant.wrong_password) {
      setState(() {
        FocusScope.of(context).unfocus();
        //User email exist. dismiss loader and let user enter otp
        toggleLoaderDialog(
          context: context,
          isLoaderPresent: _isLoaderPresent,
        );
        _isLoaderPresent = !_isLoaderPresent;
        _passwordhint = AppStrings.enter_password;
        _showPasswordField = true;
        _buttonText = AppStrings.login;
      });
      showSnackBar(message: AppStrings.wrong_password, context: context, backgroundColor: Colors.red);
    }
  }

  @override
  onSignInWithEmailCompleted(User? user) {
    print("onSignInWithEmailCompleted user $user");
    setState(() {
      FocusScope.of(context).unfocus();
      //User email exist. dismiss loader and let user enter otp
      toggleLoaderDialog(
        context: context,
        isLoaderPresent: _isLoaderPresent,
      );
      _isLoaderPresent = !_isLoaderPresent;
    });
    showSnackBar(message: AppStrings.login_success, context: context, backgroundColor: Colors.green);
    if(user?.displayName == null || user?.displayName == ""){
      print("User display name is null");
      RwNavigator.goToProfileRegistration(context: context, sourceScreen: ScreenName.loginScreen, user: user);
    }else{
      print("User display name ${user?.displayName}");
      RwNavigator.next(context: context, sourceScreen: ScreenName.loginScreen, destination: ScreenName.homeScreen);
    }
  }

  @override
  onUserCreated(User? user) {
    print("onUserCreated user $user");
    setState(() {
      FocusScope.of(context).unfocus();
      //User email exist. dismiss loader and let user enter otp
      toggleLoaderDialog(
        context: context,
        isLoaderPresent: _isLoaderPresent,
      );
      _isLoaderPresent = !_isLoaderPresent;
    });
    showSnackBar(message: AppStrings.login_success, context: context, backgroundColor: Colors.green);
    if(user?.displayName == null || user?.displayName == ""){
      print("User display name is null");
      RwNavigator.goToProfileRegistration(context: context, sourceScreen: ScreenName.loginScreen, user: user);
    }else{
      print("user display name ${user?.displayName}");
      RwNavigator.next(context: context, sourceScreen: ScreenName.loginScreen, destination: ScreenName.homeScreen);
    }
  }

  @override
  onUserEmailAlreadyExist(String email, bool canSignInWithPassword, bool canSignInWithLink) {
    print("onUserEmailAlreadyExist email $email, withpassword $canSignInWithPassword, withlink $canSignInWithLink");
    setState(() {
      FocusScope.of(context).unfocus();
      //User email exist. dismiss loader and let user enter otp
      toggleLoaderDialog(
        context: context,
        isLoaderPresent: _isLoaderPresent,
      );
      _isLoaderPresent = !_isLoaderPresent;
      _passwordhint = AppStrings.enter_password;
      _showPasswordField = true;
      _buttonText = AppStrings.login;
    });
  }

  @override
  onUserEmailNotExist(String email) {
    print("onUserEmailNotExist email $email");
    setState(() {
      FocusScope.of(context).unfocus();
      //User email exist. dismiss loader and let user enter otp
      toggleLoaderDialog(
        context: context,
        isLoaderPresent: _isLoaderPresent,
      );
      _isLoaderPresent = !_isLoaderPresent;
      _passwordhint = AppStrings.enter_password;
      _showPasswordField = true;
      _confirmPasswordhint = AppStrings.confirm_password;
      _showConfirmPasswordField = true;
      _buttonText = AppStrings.create_account;
    });
  }
}
