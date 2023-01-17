import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_local_market/components/button.dart';
import 'package:my_local_market/components/text.dart';
import 'package:my_local_market/components/textfield.dart';
import 'package:my_local_market/login_controller/login_controller.dart';
import 'package:my_local_market/login_controller/login_data_listener.dart';
import 'package:my_local_market/login_controller/login_providers.dart';
import 'package:my_local_market/values/constants.dart';
import 'package:my_local_market/values/strings.dart';

import '../../components/iconbutton.dart';
import '../../components/loaders.dart';
import '../../components/snackbar.dart';
import '../../navigator/navigator.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({Key? key}) : super(key: key);

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> implements EmailLoginStateListener {
  late LoginProviderDetails _loginProviderDetails;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final LoginController _loginController = LoginController();
  bool _isLoaderPresent = false;
  late String _info;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context) != null) {
      _loginProviderDetails = ModalRoute.of(context)!.settings.arguments as LoginProviderDetails;
    }
    _passwordController.addListener(_getPassword);
    _confirmPasswordController.addListener(_getConfirmPassword);
    _info = _getInfo(_loginProviderDetails.isNewUser);
  }

  @override
  void dispose() {
    // Clean up the controller and focus nodes when the widget is removed from the widget tree.
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              text: AppStrings.password_verification,
              textStyle: Theme.of(context).textTheme.headline1,
            ),
            const SizedBox(
              height: Constants.sized_box_base_height,
            ),
            RwText(
              text: _info,
            ),
            Column(
              children: [
                RwTextField(
                  controller: _passwordController,
                  hintText: AppStrings.enter_password,
                  label: AppStrings.password,
                ),
                if (_loginProviderDetails.isNewUser)
                  RwTextField(
                    controller: _confirmPasswordController,
                    hintText: AppStrings.confirm_password,
                    label: AppStrings.confirm_password,
                  )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: RwButton(text: AppStrings.login, onPressed: initLogin),
                ),
                const SizedBox(
                  width: Constants.sized_box_base_width * 4,
                ),
                Expanded(
                    child: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.blueAccent,
                    width: 2.0,
                  ))),
                  child: RwText(
                    text: AppStrings.forgot_password,
                    color: Colors.blue,
                    onTap: resetPassword,
                  ),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }

  void initLogin() async {
    toggleLoaderDialog(context: context, isLoaderPresent: _isLoaderPresent, loaderInfo: AppStrings.please_wait);
    _isLoaderPresent = !_isLoaderPresent;
    print("Will login");
    await _loginController.signInWithEmailAndPassword(
        emailLoginStateListener: this, email: _loginProviderDetails.loginParameter, password: _getPassword());
    User? user = FirebaseAuth.instance.currentUser;
    print("Current user: $user");
    toggleLoaderDialog(context: context, isLoaderPresent: _isLoaderPresent, loaderInfo: AppStrings.please_wait);
    _isLoaderPresent = !_isLoaderPresent;
    if (user != null) {
      RwNavigator.next(
          context: context, sourceScreen: ScreenName.phoneLoginScreen, destination: ScreenName.userProfileScreen);
    } else {
      showSnackBar(message: AppStrings.firebase_user_error, context: context);
    }
  }

  void resetPassword() {
    print("Will reset password");
  }

  String _getHeadline(LoginProvider loginProvider) {
    if (loginProvider == LoginProvider.email) {
      return AppStrings.password_verification;
    } else {
      return AppStrings.otp_verification;
    }
  }

  String _getInfo(bool isNewUser) {
    if (isNewUser) {
      return AppStrings.create_password_info;
    } else {
      return AppStrings.enter_password;
    }
  }

  String _getPassword() {
    return _passwordController.text;
  }

  String _getConfirmPassword() {
    return _confirmPasswordController.text;
  }

  @override
  onEmailAuthException(String rwFirebaseAuthException) {
    // TODO: implement onEmailAuthException
    throw UnimplementedError();
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
    // TODO: implement onUserEmailExist
    throw UnimplementedError();
  }

  @override
  onUserEmailNotExist(String email) {
    // TODO: implement onUserEmailNotExist
    throw UnimplementedError();
  }
}
