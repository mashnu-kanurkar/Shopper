import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/src/firebase_auth_exception.dart';
import 'package:flutter/material.dart';
import 'package:my_local_market/components/button.dart';
import 'package:my_local_market/components/text.dart';
import 'package:my_local_market/login_controller/login_controller.dart';
import 'package:my_local_market/login_controller/login_data_listener.dart';
import 'package:my_local_market/navigator/navigator.dart';
import '../../components/loaders.dart';
import '../../values/constants.dart';
import '../../values/strings.dart';

class LoginWelcomeScreen extends StatefulWidget {
  const LoginWelcomeScreen({Key? key}) : super(key: key);

  @override
  State<LoginWelcomeScreen> createState() => _LoginWelcomeScreenState();
}

class _LoginWelcomeScreenState extends State<LoginWelcomeScreen> implements AnonymousLoginListener {
  bool _isLoaderPresent = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Constants.base_padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Image(
                  image: AssetImage('assets/images/big_logo.jpeg'),
                  width: 200,
                  height: 200,
                ),
                const SizedBox(
                  height: Constants.sized_box_seperator_height,
                ),
                RwText(
                  text: AppStrings.login_info,
                  textStyle: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(
                  height: Constants.sized_box_seperator_height,
                ),
                RwText(
                  text: AppStrings.account_create_info,
                  textStyle: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(
                  height: Constants.sized_box_seperator_height,
                ),
                RwButton(text: AppStrings.login_with_phone, onPressed: (){
                  RwNavigator.next(context: context, sourceScreen: ScreenName.welcomeScreen, destination: ScreenName.phoneLoginScreen);
                }),
                const SizedBox(
                  height: Constants.sized_box_seperator_height,
                ),
                RwButton(text: AppStrings.login_with_email, onPressed: (){
                  RwNavigator.next(context: context, sourceScreen: ScreenName.welcomeScreen, destination: ScreenName.emailLoginScreen);
                }),
                const SizedBox(
                  height: Constants.sized_box_seperator_height,
                ),
                RwButton(text: AppStrings.skip, onPressed: initAnonymousLogin),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void initAnonymousLogin(){
    toggleLoaderDialog(context: context, isLoaderPresent: _isLoaderPresent, loaderInfo: AppStrings.please_wait);
    _isLoaderPresent = !_isLoaderPresent;
    LoginController loginController = LoginController();
    loginController.initAnonymousLogin(this);
  }

  @override
  onAnonymousSignInCompleted(UserCredential userCredential) {
    toggleLoaderDialog(context: context, isLoaderPresent: _isLoaderPresent, loaderInfo: AppStrings.please_wait);
    _isLoaderPresent = !_isLoaderPresent;
    RwNavigator.goToProfileRegistration(context: context, sourceScreen: ScreenName.welcomeScreen, user: userCredential.user);
  }

  @override
  onAnonymousSignInFailed(FirebaseAuthException firebaseAuthException) {
    toggleLoaderDialog(context: context, isLoaderPresent: _isLoaderPresent, loaderInfo: AppStrings.please_wait);
    _isLoaderPresent = !_isLoaderPresent;
  }
}
