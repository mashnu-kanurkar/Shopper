import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_local_market/components/button.dart';
import 'package:my_local_market/components/snackbar.dart';
import 'package:my_local_market/ui/homepage/homepage.dart';
import 'package:my_local_market/ui/loginscreen/LoginWelcomeScreen.dart';
import 'package:my_local_market/ui/loginscreen/login_base_screen.dart';
import 'package:my_local_market/values/strings.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  String _buttonText = AppStrings.key_continue;

  @override
  initState() {
    getButtonText();
    super.initState();
    Future.delayed(const Duration(milliseconds: 5* 1000), (){
      goToNextScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bird.png"),
          fit: BoxFit.cover,
        ),
      ),
          child: RwButton(text: _buttonText,onPressed: goToNextScreen,widthMatchParent: true,),
    ));
  }

  void goToNextScreen(){
    if(_buttonText == AppStrings.login){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginWelcomeScreen()));
    }else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  Future<String> getButtonText() async {
    if(Firebase.apps.length == 0){
      await Firebase.initializeApp();
    }
    User? user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      setState(() {
        _buttonText = AppStrings.homepage;
        showSnackBar(message: AppStrings.login_success, context: context);
      });
    }else{
      setState(() {
        _buttonText = AppStrings.login;
        showSnackBar(message: AppStrings.login_info, context: context);
      });
    }

    return _buttonText;
  }
}
