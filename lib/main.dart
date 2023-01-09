import 'package:flutter/material.dart';
import 'package:my_local_market/ui/homepage/homepage.dart';
import 'package:my_local_market/ui/loginscreen/EmailLogin.dart';
import 'package:my_local_market/ui/loginscreen/LoginWelcomeScreen.dart';
import 'package:my_local_market/ui/loginscreen/PhoneLogin.dart';
import 'package:my_local_market/ui/splashscreen/splashscreen.dart';
import 'package:my_local_market/values/screen_names.dart';
import 'values/app_theme.dart';
import 'values/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return
        MaterialApp(
          title: AppStrings.app_name,
          theme: themeData_light,
          routes: {
            '/': (context) => const Splashscreen(),
            '/${ScreenName.welcomeScreen}': (context) => const LoginWelcomeScreen(),
            '/${ScreenName.phoneLoginScreen}': (context) => const PhoneLoginScreen(),
            '/${ScreenName.emailLoginScreen}': (context) => const EmailLoginSCreen(),
            '/${ScreenName.homeScreen}': (context) => const HomePage(),
          },
        );
      },
    );

  }
}
