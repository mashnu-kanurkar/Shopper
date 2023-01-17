import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_local_market/components/button.dart';
import 'package:my_local_market/components/snackbar.dart';
import 'package:my_local_market/ui/homepage/homepage.dart';
import 'package:my_local_market/ui/loginscreen/LoginWelcomeScreen.dart';
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
    Future.delayed(const Duration(milliseconds: 2* 1000), (){
      goToNextScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bird.png"),
          fit: BoxFit.cover,
        ),
      ),
          child: RwButton(text: _buttonText,onPressed: goToNextScreen,widthMatchParent: true,),
    ));
  }

  void goToNextScreen(){
    //Navigator.pushNamed(context, '/${ScreenName.testWidget}');
    //return;
    if(_buttonText == AppStrings.login){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginWelcomeScreen()));
    }else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  Future<String> getButtonText() async {
    if(Firebase.apps.isEmpty){
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
