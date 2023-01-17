import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_local_market/components/snackbar.dart';
import 'package:my_local_market/login_controller/login_controller.dart';
import 'package:my_local_market/login_controller/login_data_listener.dart';
import 'package:my_local_market/login_controller/login_providers.dart';
import 'package:my_local_market/navigator/navigator.dart';
import 'package:my_local_market/utils/datavalidator.dart';
import '../../components/button.dart';
import '../../components/iconbutton.dart';
import '../../components/loaders.dart';
import '../../components/text.dart';
import '../../components/textfield.dart';
import '../../values/constants.dart';
import '../../values/strings.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({Key? key}) : super(key: key);

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> implements EmailLoginStateListener {
  bool _isValidEmail = false;
  final TextEditingController _emailTextController = TextEditingController();
  bool _isLoaderPresent = false;
  String _buttonText = AppStrings.register;

  bool _showPasswordField = false;
  bool _showPassword = false;
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _emailTextController.addListener(_getEmail);
    _passwordController.addListener(_getPassword);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Icons.email,
              size: 80.0,
            ),
            RwText(
              text: AppStrings.enter_email,
              textStyle: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(
              height: Constants.sized_box_base_height,
            ),
            RwText(text: AppStrings.email_info),
            const SizedBox(
              height: Constants.sized_box_base_height,
            ),
            RwTextField(
              hintText: AppStrings.enter_email,
              onChange: (text) {
                if (Validator.isValidEmail(text)) {
                  setState(() {
                    _isValidEmail = true;
                  });
                } else {
                  setState(() {
                    _isValidEmail = false;
                  });
                }
              },
              isValid: _isValidEmail,
              controller: _emailTextController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: Constants.sized_box_base_height,
            ),
            if (_showPasswordField)
              RwTextField(
                prefixIcon: IconButton(
                  onPressed: () {
                    _showPassword = !_showPassword;
                  },
                  icon: Icon(
                    _showPassword ? Icons.visibility_off : Icons.visibility,
                    size: 16.0,
                    color: Colors.teal[600],
                  ),
                ),
                onChange: (text) {

                },
                hintText: AppStrings.enter_password,
                isObscureText: _showPassword,
                controller: _passwordController,
                keyboardType: TextInputType.text,
              ),
            RwButton(
              enabled: _isValidEmail,
              text: _buttonText,
              onPressed: initEmailRegistration,
            ),
          ],
        ),
      ),
    );
  }

  String _getEmail() {
    return _emailTextController.text;
  }

  String _getPassword() {
    return _passwordController.text;
  }

  void initEmailRegistration() {
    String email = _getEmail();
    if (_isValidEmail) {
      toggleLoaderDialog(context: context, isLoaderPresent: _isLoaderPresent, loaderInfo: AppStrings.please_wait);
      _isLoaderPresent = !_isLoaderPresent;
      LoginController loginController = LoginController();
      if (_buttonText == AppStrings.register) {
        loginController.initLoginWithEmail(this, email);
      } else if (_buttonText == AppStrings.login) {
        String password = _getPassword();
        loginController.signInWithEmailAndPassword(emailLoginStateListener: this, email: email, password: password);
      }
    }
  }

  @override
  onEmailAuthException(String rwFirebaseAuthException) {
    toggleLoaderDialog(context: context, isLoaderPresent: _isLoaderPresent, loaderInfo: AppStrings.please_wait);
    _isLoaderPresent = !_isLoaderPresent;
    showSnackBar(message: "Error $rwFirebaseAuthException", context: context);
  }

  @override
  onSignInWithEmailCompleted(User? user) {
    // TODO: implement onSignInWithEmailCompleted
    throw UnimplementedError();
  }

  @override
  onUserCreated(User? user) {
    // TODO: implement onUserCreated
    throw UnimplementedError();
  }

  @override
  onUserEmailExist(String email, bool canSignInWithPassword, bool canSignInWithLink) {
    toggleLoaderDialog(context: context, isLoaderPresent: _isLoaderPresent, loaderInfo: AppStrings.please_wait);
    _isLoaderPresent = !_isLoaderPresent;
    if (canSignInWithPassword) {
      //show password fields
      _buttonText = AppStrings.login;
      _showPasswordField = true;
      toggleLoaderDialog(context: context, isLoaderPresent: _isLoaderPresent, loaderInfo: AppStrings.please_wait);
      _isLoaderPresent = !_isLoaderPresent;
      RwNavigator.next(context: context, sourceScreen: ScreenName.emailLoginScreen, destination: ScreenName.passwordScreen, arguments: LoginProviderDetails(LoginProvider.email, email, false));

    } else if (canSignInWithLink) {
      //auth user with links
    }
  }

  @override
  onUserEmailNotExist(String email) {
    toggleLoaderDialog(context: context, isLoaderPresent: _isLoaderPresent, loaderInfo: AppStrings.please_wait);
    _isLoaderPresent = !_isLoaderPresent;
    showSnackBar(message: AppStrings.verif_email_sent_info, context: context);
    RwNavigator.next(context: context, sourceScreen: ScreenName.emailLoginScreen, destination: ScreenName.passwordScreen, arguments: LoginProviderDetails(LoginProvider.email, email, true));
  }
}
