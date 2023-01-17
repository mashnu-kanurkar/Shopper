import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_local_market/logger/logger.dart';
import 'package:my_local_market/navigator/navigator.dart';
import 'values/app_theme.dart';
import 'values/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



void main() async {
  HttpOverrides.global = MyHttpOverrides();
  Logger().setLogLevel(LogLevel.DEBUG);
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
          //routes: RwNavigator.routes(context),
          onGenerateRoute: RwNavigator.routeFactory,
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
