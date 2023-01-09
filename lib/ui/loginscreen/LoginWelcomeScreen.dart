import 'package:flutter/material.dart';
import 'package:my_local_market/components/button.dart';
import 'package:my_local_market/components/text.dart';
import 'package:my_local_market/navigator/navigator.dart';
import 'package:my_local_market/values/screen_names.dart';
import '../../values/constants.dart';
import '../../values/images_urls.dart';
import '../../values/strings.dart';

class LoginWelcomeScreen extends StatelessWidget {
  const LoginWelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(ImagesURLs.loginWelcomeBg),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            margin: EdgeInsets.all(Constants.base_margin),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Image(
                  image: AssetImage('assets/images/big_logo.jpeg'),
                  width: 200,
                  height: 200,
                ),
                const SizedBox(
                  height: Constants.sized_box_base_height,
                ),
                RwText(
                  text: AppStrings.login_info,
                  textStyle: Theme.of(context).textTheme.headline1,
                ),
                const SizedBox(
                  height: Constants.sized_box_base_height,
                ),
                RwText(
                  text: AppStrings.account_create_info,
                  textStyle: Theme.of(context).textTheme.bodyText1,
                ),
                const SizedBox(
                  height: Constants.sized_box_base_height,
                ),
                RwButton(text: AppStrings.login_with_phone, onPressed: (){
                  RwNavigator.next(context: context, sourceScreen: ScreenName.welcomeScreen, destination: ScreenName.phoneLoginScreen);
                }),
                const SizedBox(
                  height: Constants.sized_box_base_height,
                ),
                RwButton(text: AppStrings.login_with_email, onPressed: (){
                  RwNavigator.next(context: context, sourceScreen: ScreenName.welcomeScreen, destination: ScreenName.emailLoginScreen);
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
