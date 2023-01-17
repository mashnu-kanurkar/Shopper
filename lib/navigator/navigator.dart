import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_local_market/ui/profilescreen/profilescreen.dart';
import 'package:my_local_market/utils/test.dart';
import 'package:my_local_market/values/strings.dart';
import '../ui/homepage/homepage.dart';
import '../ui/loginscreen/EmailLogin.dart';
import '../ui/loginscreen/LoginWelcomeScreen.dart';
import '../ui/loginscreen/OtpScreen.dart';
import '../ui/loginscreen/PhoneLogin.dart';
import '../ui/splashscreen/splashscreen.dart';

class ScreenName {
  static const testWidget = "TestWidget";
  static const splashScreen = "SplashScreen";
  static const welcomeScreen = "WelComeScreen";
  static const loginScreen = "LoginScreen";
  static const phoneLoginScreen = "PhoneLoginScreen";
  static const emailLoginScreen = "EmailLoginScreen";
  static const passwordScreen = "PasswordScreen";
  static const otpScreen = "OtpScreen";
  static const homeScreen = "HomeScreen";
  static const userProfileScreen = "UserProfileScreen";
}

class RwNavigator {
  static PageRouteBuilder? routeFactory(RouteSettings settings) {
    switch (settings.name) {
      case ('/${ScreenName.homeScreen}'):
        return pageBuilder();
        break;
    }
    return null;
  }

  static PageRouteBuilder pageBuilder(){
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );
          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        });
  }

  static Map<String, WidgetBuilder> routes(BuildContext context) => {
        '/': (context) => const Splashscreen(),
        '/${ScreenName.testWidget}': (context, ) => const TestWidget(),
        '/${ScreenName.welcomeScreen}': (context) => const LoginWelcomeScreen(),
        '/${ScreenName.phoneLoginScreen}': (context) => const PhoneLoginScreen(),
        '/${ScreenName.emailLoginScreen}': (context) => const EmailLoginScreen(),
        '/${ScreenName.homeScreen}': (context) => const HomePage(),
        '/${ScreenName.userProfileScreen}': (context) => const ProfileScreen(),
        '/${ScreenName.passwordScreen}': (context) => const OtpScreen(),
        '/${ScreenName.otpScreen}': (context) => const OtpScreen(),
      };

  RwNavigator.next(
      {required BuildContext context, required String sourceScreen, required String destination, Object? arguments}) {
    if (sourceScreen == ScreenName.phoneLoginScreen) {
      Navigator.pushReplacementNamed(context, "/${ScreenName.homeScreen}");
      return;
    }
    if (sourceScreen == ScreenName.welcomeScreen &&
        destination == ScreenName.phoneLoginScreen &&
        arguments != AppStrings.phone_number) {
      Navigator.pushNamed(
        context,
        "/${ScreenName.phoneLoginScreen}",
      );
      return;
    }
    if (sourceScreen == ScreenName.welcomeScreen &&
        destination == ScreenName.emailLoginScreen &&
        arguments != AppStrings.email) {
      Navigator.pushNamed(
        context,
        "/${ScreenName.emailLoginScreen}",
      );
      return;
    }
    if (sourceScreen == ScreenName.emailLoginScreen && destination == ScreenName.userProfileScreen) {
      Navigator.pushNamed(context, "/${ScreenName.userProfileScreen}");
      return;
    }
    if (sourceScreen == ScreenName.emailLoginScreen && destination == ScreenName.homeScreen) {
      Navigator.pushNamed(context, "/${ScreenName.homeScreen}");
      return;
    }

    if (sourceScreen == ScreenName.emailLoginScreen && destination == ScreenName.passwordScreen) {
      Navigator.pushNamed(context, "/${ScreenName.passwordScreen}", arguments: arguments);
    }
    if (sourceScreen == ScreenName.phoneLoginScreen && destination == ScreenName.passwordScreen) {
      Navigator.pushNamed(context, "/${ScreenName.passwordScreen}", arguments: arguments);
    }
  }

  RwNavigator.pop({
    required BuildContext context,
  }) {
    Navigator.pop(context);
  }

  RwNavigator.goToProfileRegistration({
    required BuildContext context,
    required String sourceScreen,
    required User? user,
  }) {
    if (user != null) {
      if (sourceScreen == ScreenName.welcomeScreen || sourceScreen == ScreenName.otpScreen) {
        Navigator.pushReplacementNamed(context, "/${ScreenName.userProfileScreen}");
        return;
      }
      if (sourceScreen == ScreenName.homeScreen) {
        Navigator.pushNamed(context, "/${ScreenName.userProfileScreen}");
        return;
      }
    }
  }
}
