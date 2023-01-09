import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_local_market/ui/profilescreen/profilescreen.dart';
import 'package:my_local_market/values/screen_names.dart';
import 'package:my_local_market/values/strings.dart';

class RwNavigator{
  RwNavigator.next({required BuildContext context, required String sourceScreen, required String destination, dynamic arguments}){
    if(sourceScreen == ScreenName.phoneLoginScreen){
      Navigator.pushReplacementNamed(context, "/${ScreenName.homeScreen}");
      return;
    }
    if(sourceScreen == ScreenName.welcomeScreen && destination == ScreenName.phoneLoginScreen && arguments != AppStrings.phone_number){
      Navigator.pushNamed(context, "/${ScreenName.phoneLoginScreen}",);
      return;
    }
    if(sourceScreen == ScreenName.welcomeScreen && destination == ScreenName.emailLoginScreen && arguments != AppStrings.email){
      Navigator.pushNamed(context, "/${ScreenName.emailLoginScreen}",);
      return;
    }
  }

  RwNavigator.goToProfileRegistration({required BuildContext context, required String sourceScreen, required User? user,}){
    if(user != null){
      if(sourceScreen == ScreenName.loginScreen){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen(user: user)),);
        return;
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen(user: user)));
        return;
      }
    }
  }
}